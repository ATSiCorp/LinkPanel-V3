#!/bin/bash

# LinkPanel Control Panel upgrade script for target version 1.9.0

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################
####### upgrade_config_set_value only accepts true or false.                    #######
#######                                                                         #######
####### Pass through information to the end user in case of a issue or problem  #######
#######                                                                         #######
####### Use add_upgrade_message "My message here" to include a message          #######
####### in the upgrade notification email. Example:                             #######
#######                                                                         #######
####### add_upgrade_message "My message here"                                   #######
#######                                                                         #######
####### You can use \n within the string to create new lines.                   #######
#######################################################################################

upgrade_config_set_value 'UPGRADE_UPDATE_WEB_TEMPLATES' 'false'
upgrade_config_set_value 'UPGRADE_UPDATE_DNS_TEMPLATES' 'false'
upgrade_config_set_value 'UPGRADE_UPDATE_MAIL_TEMPLATES' 'false'
upgrade_config_set_value 'UPGRADE_REBUILD_USERS' 'yes'
upgrade_config_set_value 'UPGRADE_UPDATE_FILEMANAGER_CONFIG' 'false'

# update config sftp jail
$BIN/v-delete-sys-sftp-jail
$BIN/v-add-sys-sftp-jail

codename="$(lsb_release -s -c)"
apt=/etc/apt/sources.list.d

# Installing Node.js 20.x repo
if [ ! -f $apt/nodesource.list ] && [ ! -z $(which "node") ]; then
	echo "[ * ] Adding Node.js 20.x repo"
	echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x $codename main" > $apt/nodesource.list
	echo "deb-src [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x $codename main" >> $apt/nodesource.list
	curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee /usr/share/keyrings/nodesource.gpg > /dev/null 2>&1
fi

# Check if linkpanelweb exists
if [ -z "$(grep ^linkpanelweb: /etc/passwd)" ]; then
	# Generate a random password
	random_password=$(generate_password '32')
	# Create the new linkpanelweb user
	/usr/sbin/useradd "linkpanelweb" -c "$email" --no-create-home
	# do not allow login into linkpanelweb user
	echo linkpanelweb:$random_password | sudo chpasswd -e
	cp $LINKPANEL_COMMON_DIR/sudo/linkpanelweb /etc/sudoers.d/
	# Keep enabled for now
	# Remove sudo permissions admin user
	#rm /etc/sudoers.d/admin/
fi

# Check if cronjobs have been migrated
if [ ! -f "/var/spool/cron/crontabs/linkpanelweb" ]; then
	echo "MAILTO=\"\"" > /var/spool/cron/crontabs/linkpanelweb
	echo "CONTENT_TYPE=\"text/plain; charset=utf-8\"" >> /var/spool/cron/crontabs/linkpanelweb
	while read line; do
		parse_object_kv_list "$line"
		if [ -n "$(echo "$CMD" | grep ^sudo)" ]; then
			echo "$MIN $HOUR $DAY $MONTH $WDAY $CMD" \
				| sed -e "s/%quote%/'/g" -e "s/%dots%/:/g" \
					>> /var/spool/cron/crontabs/linkpanelweb
			$BIN/v-delete-cron-job admin "$JOB"
		fi
	done < $LINKPANEL/data/users/admin/cron.conf
	# Update permissions
	chmod 600 /var/spool/cron/crontabs/linkpanelweb
	chown linkpanelweb:linkpanelweb /var/spool/cron/crontabs/linkpanelweb

fi

chown linkpanelweb:linkpanelweb /usr/local/linkpanel/data/sessions

packages=$(ls --sort=time $LINKPANEL/data/packages | grep .pkg)
for package in $packages; do
	if [ -z "$(grep -e 'SHELL_JAIL_ENABLED' $LINKPANEL/data/packages/$package)" ]; then
		echo "SHELL_JAIL_ENABLED='no'" >> $LINKPANEL/data/packages/$package
	fi
	# Add additional key-value pairs if they don't exist
	for key in DISK_QUOTA CPU_QUOTA CPU_QUOTA_PERIOD MEMORY_LIMIT SWAP_LIMIT; do
		if [ -z "$(grep -e "$key" $LINKPANEL/data/packages/$package)" ]; then
			echo "$key='unlimited'" >> $LINKPANEL/data/packages/$package
		fi
	done
done

$BIN/v-add-user-notification 'admin' 'LinkPanel securirty has been upgraded' 'Here should come a nice message about the upgrade and how to change the user name of the admin user!'
add_upgrade_message 'Here should come a nice message about the upgrade and how to change the user name of the admin user!'
#!/bin/bash

# Function Description
# Manual upgrade script from Nginx + Apache2 + PHP-FPM to Nginx + PHP-FPM

#----------------------------------------------------------#
#                    Variable&Function                     #
#----------------------------------------------------------#

# Includes
# shellcheck source=/etc/hestiacp/linkpanel.conf
source /etc/hestiacp/linkpanel.conf
# shellcheck source=/usr/local/linkpanel/func/main.sh
source $LINKPANEL/func/main.sh
# shellcheck source=/usr/local/linkpanel/conf/linkpanel.conf
source $LINKPANEL/conf/linkpanel.conf

#----------------------------------------------------------#
#                    Verifications                         #
#----------------------------------------------------------#

if [ "$WEB_BACKEND" != "php-fpm" ]; then
	check_result $E_NOTEXISTS "PHP-FPM is not enabled" > /dev/null
	exit 1
fi

if [ "$WEB_SYSTEM" != "apache2" ]; then
	check_result $E_NOTEXISTS "Apache2 is not enabled" > /dev/null
	exit 1
fi

#----------------------------------------------------------#
#                       Action                             #
#----------------------------------------------------------#

# Remove apache2 from config
sed -i "/^WEB_PORT/d" $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf
sed -i "/^WEB_SSL/d" $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf
sed -i "/^WEB_SSL_PORT/d" $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf
sed -i "/^WEB_RGROUPS/d" $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf
sed -i "/^WEB_SYSTEM/d" $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf

# Remove nginx (proxy) from config
sed -i "/^PROXY_PORT/d" $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf
sed -i "/^PROXY_SSL_PORT/d" $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf
sed -i "/^PROXY_SYSTEM/d" $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf

# Add Nginx settings to config
echo "WEB_PORT='80'" >> $LINKPANEL/conf/linkpanel.conf
echo "WEB_SSL='openssl'" >> $LINKPANEL/conf/linkpanel.conf
echo "WEB_SSL_PORT='443'" >> $LINKPANEL/conf/linkpanel.conf
echo "WEB_SYSTEM='nginx'" >> $LINKPANEL/conf/linkpanel.conf

# Add Nginx settings to config
echo "WEB_PORT='80'" >> $LINKPANEL/conf/defaults/linkpanel.conf
echo "WEB_SSL='openssl'" >> $LINKPANEL/conf/defaults/linkpanel.conf
echo "WEB_SSL_PORT='443'" >> $LINKPANEL/conf/defaults/linkpanel.conf
echo "WEB_SYSTEM='nginx'" >> $LINKPANEL/conf/defaults/linkpanel.conf

rm $LINKPANEL/conf/defaults/linkpanel.conf
cp $LINKPANEL/conf/linkpanel.conf $LINKPANEL/conf/defaults/linkpanel.conf

# Rebuild web config

for user in $($BIN/v-list-users plain | cut -f1); do
	echo $user
	for domain in $($BIN/v-list-web-domains $user plain | cut -f1); do
		$BIN/v-change-web-domain-tpl $user $domain 'default'
		$BIN/v-rebuild-web-domain $user $domain no
	done
done

systemctl restart nginx

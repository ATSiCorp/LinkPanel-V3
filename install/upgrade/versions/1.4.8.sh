#!/bin/bash

# LinkPanel Control Panel upgrade script for target version 1.4.8

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################

echo "[ * ] Configuring PHPMailer..."
$LINKPANEL/bin/v-add-sys-phpmailer quiet

matches=$(grep -o 'ENFORCE_SUBDOMAIN_OWNERSHIP' $LINKPANEL/conf/linkpanel.conf | wc -l)
if [ "$matches" -gt 1 ]; then
	echo "[ * ] Removing double matches ENFORCE_SUBDOMAIN_OWNERSHIP key"
	source $LINKPANEL/conf/linkpanel.conf
	sed -i "/ENFORCE_SUBDOMAIN_OWNERSHIP='$ENFORCE_SUBDOMAIN_OWNERSHIP'/d" $LINKPANEL/conf/linkpanel.conf
	$LINKPANEL/bin/v-change-sys-config-value "ENFORCE_SUBDOMAIN_OWNERSHIP" "$ENFORCE_SUBDOMAIN_OWNERSHIP"
fi

if [ "$IMAP_SYSTEM" = "dovecot" ]; then
	version=$(dovecot --version | cut -f -2 -d .)
	if [ "$version" = "2.3" ]; then
		echo "[ * ] Update dovecot config to sync with 2.3 settings"
		sed -i 's|ssl_dh_parameters_length = 4096|#ssl_dh_parameters_length = 4096|g' /etc/dovecot/conf.d/10-ssl.conf
		sed -i 's|#ssl_dh = </etc/ssl/dhparam.pem|ssl_dh = </etc/ssl/dhparam.pem|g' /etc/dovecot/conf.d/10-ssl.conf
		sed -i 's|ssl_protocols = !SSLv3 !TLSv1|ssl_min_protocol=TLSv1.1|g' /etc/dovecot/conf.d/10-ssl.conf
	fi
fi

#!/bin/bash

# LinkPanel Control Panel upgrade script for target version 1.3.3

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################

# Check if keys folder exists and adjust permissions
if [ -d "$LINKPANEL/data/keys" ]; then
	echo '[ * ] Update permissions'
	chmod 750 "$LINKPANEL/data/keys"
	chown admin:root "$LINKPANEL/data/keys"
fi

if [[ ! -e /etc/hestiacp/linkpanel.conf ]]; then
	echo '[ * ] Create global LinkPanel config'

	mkdir -p /etc/hestiacp
	echo -e "# Do not edit this file, will get overwritten on next upgrade, use /etc/hestiacp/local.conf instead\n\nexport LINKPANEL='/usr/local/linkpanel'\n\n[[ -f /etc/hestiacp/local.conf ]] && source /etc/hestiacp/local.conf" > /etc/hestiacp/linkpanel.conf
fi

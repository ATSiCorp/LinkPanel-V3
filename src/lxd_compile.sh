#!/bin/bash

branch=${1-main}

apt -y install curl wget

curl https://raw.githubusercontent.com/ATSiCorp/LinkPanel-V3/$branch/src/hst_autocompile.sh > /tmp/hst_autocompile.sh
chmod +x /tmp/hst_autocompile.sh

mkdir -p /opt/linkpanelcp

# Building LinkPanel
if bash /tmp/hst_autocompile.sh --linkpanel --noinstall --keepbuild $branch; then
	cp /tmp/linkpanelcp-src/deb/*.deb /opt/linkpanelcp/
fi

# Building PHP
if bash /tmp/hst_autocompile.sh --php --noinstall --keepbuild $branch; then
	cp /tmp/linkpanelcp-src/deb/*.deb /opt/linkpanelcp/
fi

# Building NGINX
if bash /tmp/hst_autocompile.sh --nginx --noinstall --keepbuild $branch; then
	cp /tmp/linkpanelcp-src/deb/*.deb /opt/linkpanelcp/
fi

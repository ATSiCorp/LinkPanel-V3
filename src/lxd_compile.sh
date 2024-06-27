#!/bin/bash

branch=${1-main}

apt -y install curl wget

curl https://raw.githubusercontent.com/ATSiCorp/LinkPanel-V3/$branch/src/linkpnl_autocompile.sh > /tmp/linkpnl_autocompile.sh
chmod +x /tmp/linkpnl_autocompile.sh

mkdir -p /opt/linkpanelcp

# Building LinkPanel
if bash /tmp/linkpnl_autocompile.sh --linkpanel --noinstall --keepbuild $branch; then
	cp /tmp/linkpanelcp-src/deb/*.deb /opt/linkpanelcp/
fi

# Building PHP
if bash /tmp/linkpnl_autocompile.sh --php --noinstall --keepbuild $branch; then
	cp /tmp/linkpanelcp-src/deb/*.deb /opt/linkpanelcp/
fi

# Building NGINX
if bash /tmp/linkpnl_autocompile.sh --nginx --noinstall --keepbuild $branch; then
	cp /tmp/linkpanelcp-src/deb/*.deb /opt/linkpanelcp/
fi

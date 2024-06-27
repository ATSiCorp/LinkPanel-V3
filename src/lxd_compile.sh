#!/bin/bash

branch=${1-main}

apt -y install curl wget

curl https://raw.githubusercontent.com/hestiacp/hestiacp/$branch/src/hst_autocompile.sh > /tmp/hst_autocompile.sh
chmod +x /tmp/hst_autocompile.sh

mkdir -p /opt/hestiacp

# Building LinkPanel
if bash /tmp/hst_autocompile.sh --linkpanel --noinstall --keepbuild $branch; then
	cp /tmp/hestiacp-src/deb/*.deb /opt/hestiacp/
fi

# Building PHP
if bash /tmp/hst_autocompile.sh --php --noinstall --keepbuild $branch; then
	cp /tmp/hestiacp-src/deb/*.deb /opt/hestiacp/
fi

# Building NGINX
if bash /tmp/hst_autocompile.sh --nginx --noinstall --keepbuild $branch; then
	cp /tmp/hestiacp-src/deb/*.deb /opt/hestiacp/
fi

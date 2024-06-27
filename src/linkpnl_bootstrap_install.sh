#!/bin/bash

# Clean installation bootstrap for development purposes only
# Usage:    ./linkpnl_bootstrap_install.sh [fork] [branch] [os]
# Example:  ./linkpnl_bootstrap_install.sh linkpanelcp main ubuntu

# Define variables
fork=$1
branch=$2
os=$3

# Download specified installer and compiler
wget https://raw.githubusercontent.com/$fork/linkpanelcp/$branch/install/linkpnl-install-$os.sh
wget https://raw.githubusercontent.com/$fork/linkpanelcp/$branch/src/linkpnl_autocompile.sh

# Execute compiler and build linkpanel core package
chmod +x linkpnl_autocompile.sh
./linkpnl_autocompile.sh --linkpanel $branch no

# Execute LinkPanel Control Panel installer with default dummy options for testing
if [ -f "/etc/redhat-release" ]; then
	bash linkpnl-install-$os.sh -f -y no -e admin@test.local -p P@ssw0rd -s linkpanel-$branch-$os.test.local --with-rpms /tmp/linkpanelcp-src/rpms
else
	bash linkpnl-install-$os.sh -f -y no -e admin@test.local -p P@ssw0rd -s linkpanel-$branch-$os.test.local --with-debs /tmp/linkpanelcp-src/debs
fi

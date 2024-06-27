#!/bin/bash

for file in /usr/local/linkpanel/bin/*; do
	echo "$file" >> ~/linkpanel_cli_help.txt
	[ -f "$file" ] && [ -x "$file" ] && "$file" >> ~/linkpanel_cli_help.txt
done

sed -i 's\/usr/local/linkpanel/bin/\\' ~/linkpanel_cli_help.txt

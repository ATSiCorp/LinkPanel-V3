# API

::: info
This page is work in progress. A lot of information will be missing.
:::

## Examples

Examples can be found in a separate [repo](https://github.com/linkpanelcp/linkpanelcp-api-examples).

## Upgrading from username/password authentication to access/secret keys

Replace the following code:

```php
// Prepare POST query
$postvars = [
	"user" => $linkpnl_username,
	"password" => $linkpnl_password,
	"returncode" => $linkpnl_returncode,
	"cmd" => $linkpnl_command,
	"arg1" => $username,
];
```

With the following:

```php
// Prepare POST query
$postvars = [
	"hash" => "access_code:secret_code",
	"returncode" => $linkpnl_returncode,
	"cmd" => $linkpnl_command,
	"arg1" => $username,
];
```

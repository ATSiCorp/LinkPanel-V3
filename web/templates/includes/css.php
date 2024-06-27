<link rel="alternate icon" href="/images/favicon.png" type="image/png">
<link rel="icon" href="/images/logo.svg" type="image/svg+xml">
<link rel="stylesheet" href="/css/themes/default.min.css?<?= JS_LATEST_UPDATE ?>">

<?php
$selected_theme = !empty($_SESSION["userTheme"]) ? $_SESSION["userTheme"] : $_SESSION["THEME"];
// Load non-default theme
if ($selected_theme !== "default") {
	// Load LinkPanelCP-shipped themes (minified, updated/overwritten with updates) - ($LINKPANEL/web/css/themes/*.min.css)
	$non_default_theme_path = $_SERVER["LINKPANEL"] . "/web/css/themes/" . $selected_theme . ".min.css";
	if (file_exists($non_default_theme_path)) {
		echo '<link rel="stylesheet" href="/css/themes/' . $selected_theme . ".min.css?" . JS_LATEST_UPDATE . '">';
	}
	// Load custom theme files ($LINKPANEL/web/css/themes/custom/*.css)
	else {
		$custom_theme_path = $_SERVER["LINKPANEL"] . "/web/css/themes/custom/" . $selected_theme . ".min.css";
		if (file_exists($custom_theme_path)) {
			echo '<link rel="stylesheet" href="/css/themes/custom/' . $selected_theme . ".min.css?" . JS_LATEST_UPDATE . '">';
		} else {
			echo '<link rel="stylesheet" href="/css/themes/custom/' . $selected_theme . ".css?" . JS_LATEST_UPDATE . '">';
		}
	}
}

?>

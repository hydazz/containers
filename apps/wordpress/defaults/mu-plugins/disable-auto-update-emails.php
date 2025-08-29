<?php
/**
 * MU Plugin: Disable Auto-Update Email Notifications
 * Disables email notifications for automatic plugin and theme updates.
 */

if (!defined('ABSPATH')) {
	exit;
}

// Disable plugin auto-update email notification
add_filter('auto_plugin_update_send_email', '__return_false');

// Disable theme auto-update email notification
add_filter('auto_theme_update_send_email', '__return_false');

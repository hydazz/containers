<?php
/**
 * MU Plugin: Health Endpoint
 * Responds to /health with 200 if WP+DB are OK.
 */

if (!defined('ABSPATH')) {
    exit;
}

add_action('muplugins_loaded', function () {
    // Serve for /health
    $uri = isset($_SERVER['REQUEST_URI']) ? strtok($_SERVER['REQUEST_URI'], '?') : '';
    if ($uri !== '/health' && $uri !== '/health/') {
        return;
    }

    global $wpdb;
    $ok = true;
    if (method_exists($wpdb, 'check_connection')) {
        $ok = $wpdb->check_connection(false);
    } else {
        $ok = (bool) $wpdb->query('SELECT 1');
    }

    if ($ok) {
        status_header(200);
        if (!headers_sent()) {
            header('Content-Length: 0');
        }
        exit;
    }

    status_header(503);
    if (!headers_sent()) {
        header('Content-Type: text/plain; charset=utf-8');
    }
    echo 'No DB connection';
    exit;
});

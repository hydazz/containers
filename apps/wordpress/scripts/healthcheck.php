<?php
/**
 * Health Endpoint Drop-in
 *
 * Based on the Health Endpoint plugin by Jon Otaegi
 * Original: https://wordpress.org/plugins/health-endpoint/
 * License: GPLv3
 * 
 * Creates a /health endpoint that returns a 200 OK HTTP status code 
 * while WordPress is performing correctly.
 */

// If this file is called directly, abort.
if (!defined('WPINC')) {
    die;
}

/**
 * Filter the list of public query vars in order to allow the WP::parse_request to register the query variable.
 */
function health_check_query_var($public_query_vars) {
    $public_query_vars[] = "health_check";
    return $public_query_vars;
}

/**
 * Hook the parse_request action and serve the health endpoint when custom query variable is set to 'true'.
 */
function health_check_request($wp) {
    if (isset($wp->query_vars["health_check"]) && "true" === $wp->query_vars["health_check"]) {
        // Use the global instance created by WordPress
        global $wpdb;

        // Check the connection:
        if (!$wpdb->check_connection($allow_bail = false)) {
            die(__("No DB connection"));
        }

        header("Content-length: 0");
        exit;
    }
}

/**
 * Register the rewrite rule for /health request.
 */
function health_endpoint_rewrite() {
    add_rewrite_rule("^health$", "index.php?health_check=true", "top");
    flush_rewrite_rules();
}

// Hook into WordPress
add_filter("query_vars", "health_check_query_var", 10, 1);
add_action("parse_request", "health_check_request", 10, 1);
add_action("init", "health_endpoint_rewrite", 10);

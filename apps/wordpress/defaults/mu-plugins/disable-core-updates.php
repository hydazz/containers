<?php
/**
 * Plugin Name: Disable Core Updates (MU)
 * Description: Disables WordPress core updates
 */

if (!defined("ABSPATH")) {
    exit();
}

/**
 * Disable all automatic core updates
 */
add_filter("allow_dev_auto_core_updates", "__return_false", 999, 0);
add_filter("allow_minor_auto_core_updates", "__return_false", 999, 0);
add_filter("allow_major_auto_core_updates", "__return_false", 999, 0);
add_filter("auto_update_core", "__return_false", 999, 0);

/**
 * Remove capability to run core updates via UI.
 */
add_filter(
    "map_meta_cap",
    function ($caps, $cap) {
        if ($cap === "update_core") {
            return ["do_not_allow"];
        }
        return $caps;
    },
    10,
    2
);

/**
 * Add notice on the Updates screen.
 */
add_action("admin_notices", function () {
    $screen = function_exists("get_current_screen")
        ? get_current_screen()
        : null;
    if ($screen && $screen->id === "update-core") {
        echo '<div class="notice notice-info" id="core-update-notice"><p>Core updates are managed by your site administrator.</p></div>';
    }
});

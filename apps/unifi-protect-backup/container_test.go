package main

import (
	"testing"

	helpers "github.com/hydazz/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/hydazz/unifi-protect-backup:rolling")

	// Without an NVR, startup gets as far as the connect loop, past the notifier and rclone checks.
	// The default destination, local:/data, is only writable with a mounted volume.
	helpers.RequireLogContains(t, image, &helpers.ContainerConfig{
		Env: map[string]string{
			"RCLONE_DESTINATION": "local:/tmp",
			"UFP_PASSWORD":       "test",
			"UFP_USERNAME":       "test",
		},
	}, "Connecting to Unifi Protect")
}

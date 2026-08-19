package main

import (
	"testing"

	helpers "github.com/hydazz/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/hydazz/unifi-protect-backup:rolling")
	helpers.RequireCommandSucceeds(t, image, nil, "unifi-protect-backup", "--version")
}

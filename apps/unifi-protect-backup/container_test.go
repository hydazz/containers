package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/unifi-protect-backup:rolling")
	testhelpers.TestCommandSucceeds(t, image, nil, "unifi-protect-backup", "--version")
}

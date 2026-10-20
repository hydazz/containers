package main

import (
	"testing"

	"github.com/stretchr/testify/require"

	helpers "github.com/hydazz/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/hydazz/prtgmpprobe:rolling")

	// Modules load before the first NATS connection attempt, so no server is needed.
	logs := helpers.RequireLogMatch(t, image, &helpers.ContainerConfig{
		Env: map[string]string{
			"PRTGMPPROBE__ID":         "0f2dcfe4-3ea4-4fd8-99d1-f22bd923544a",
			"PRTGMPPROBE__NAME":       "container-test",
			"PRTGMPPROBE__ACCESS_KEY": "access-key",
			"PRTGMPPROBE__NATS__URL":  "nats://127.0.0.1:4222",
		},
	}, `Loaded \d+ modules`)
	require.NotContains(t, logs, "Loading module failed")
}

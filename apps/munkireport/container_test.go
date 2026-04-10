package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/munkireport:rolling")

	t.Run("php-modules", func(t *testing.T) {
		testhelpers.TestCommandSucceeds(t, ctx, image, nil, "sh", "-c",
			"php -m | tr -d '\\r' | grep -Fxq ldap && "+
				"php -m | tr -d '\\r' | grep -Fxq pdo_mysql && "+
				"php -m | tr -d '\\r' | grep -Fxq pdo_sqlite && "+
				"php -m | tr -d '\\r' | grep -Fxq soap && "+
				"php -m | tr -d '\\r' | grep -Fxq zip",
		)
	})

	t.Run("source-present", func(t *testing.T) {
		testhelpers.TestCommandSucceeds(t, ctx, image, nil, "sh", "-c",
			"test -f /usr/src/munkireport/public/index.php",
		)
	})
}

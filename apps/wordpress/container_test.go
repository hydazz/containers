package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/wordpress:rolling")

	t.Run("php-modules", func(t *testing.T) {
		testhelpers.TestCommandSucceeds(t, ctx, image, nil, "sh", "-c",
			"php -m | tr -d '\\r' | grep -Fxq redis && "+
				"php -m | tr -d '\\r' | grep -Fxq bz2 && "+
				"php -m | tr -d '\\r' | grep -Fxq gettext && "+
				"php -m | tr -d '\\r' | grep -Fxq gmp && "+
				"php -m | tr -d '\\r' | grep -Fxq pcntl && "+
				"php -m | tr -d '\\r' | grep -Fxq soap && "+
				"php -m | tr -d '\\r' | grep -Fxq tidy && "+
				"php -m | tr -d '\\r' | grep -Fxq xsl",
		)
	})

	t.Run("wp-cli-version", func(t *testing.T) {
		testhelpers.TestCommandSucceeds(t, ctx, image, nil, "sh", "-c",
			"wp --allow-root --version | grep -Fq 'WP-CLI'",
		)
	})
}

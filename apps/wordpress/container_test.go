package main

import (
	"testing"

	helpers "github.com/hydazz/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/hydazz/wordpress:rolling")

	t.Run("php-modules", func(t *testing.T) {
		helpers.RequireCommandSucceeds(t, image, nil, "sh", "-c",
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
		helpers.RequireCommandSucceeds(t, image, nil, "sh", "-c",
			"wp --allow-root --version | grep -Fq 'WP-CLI'",
		)
	})
}

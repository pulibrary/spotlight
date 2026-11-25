spotlight
=========

This fork of spotlight supports our DPUL app.

## Requirements

1. Ruby (see .tool-versions)
3. Java (7 or greater, needed if running solr_wrapper
4. ImageMagick (http://www.imagemagick.org/script/index.php) due to [carrierwave](https://github.com/carrierwaveuploader/carrierwave#adding-versions)

# Developing Spotlight

Spotlight:

* is a Rails engine and needs to be used in the context of a Rails application. We don't use [engine_cart](https://github.com/cbeer/engine_cart) anymore; we just have a permanent internal test application at .internal_test_app/
* Spotlight relies on Solr for its integration tests and to run a development instance. [solr_wrapper](https://github.com/cbeer/solr_wrapper) allows us to provide terse commands for development and testing. For more granular control you can run Solr in Docker, then execute services and processes individually.

Our `$ rake ci` and `$ rake spotlight:server` tasks utilize Solr and the testing rails app automatically.

See more detailed instructions for development environment setup at ["Contributing to Spotlight"](https://github.com/projectblacklight/spotlight/wiki/Contributing-to-Spotlight)

## Run a development server

After following one of the instructions below, visit http://localhost:3000. A Solr instance will be running on port 8983. When using importmap (the default configuration), JavaScript changes in development should not require [bundling](#updating-the-javascript-bundle) or a server restart.

### With solr_wrapper
```sh
rake spotlight:server
```

### With Docker
```sh
docker compose up -d
rake engine_cart:generate
rake spotlight:fixtures
cd .internal_test_app
rake spotlight:seed_admin_user
bin/dev
```

## Yarn link

When spotlight uses engine_cart, one thing that the generators do is link the spotlight-frontend to the engine code, so that you can change it in the project and see it reflected in the test app. Since we're not running that generator anymore, you may have to do it manually. In the top-level of this project run `yarn link` and then in the test app directory run `yarn link spotlight-frontent`

## Tests

### With solr_wrapper

```sh
rake
```

This runs rubocop style enforcement and then all tests, starting solr and building the testing rails app automatically.

### With Docker

```sh
docker compose up -d
rake engine_cart:generate
rake spotlight:fixtures
cd .internal_test_app && rake spec:prepare && cd - # not needed if you ran the dev server
rspec
```

Using rspec directly allows you to run individual test files / lines.

## Translations

Spotlight ships with [`i18n-tasks`](https://github.com/glebm/i18n-tasks) to help manage translations. To run a translation health check:

```sh
$ bundle exec i18n-tasks health
```

See [developer-facing instructions for enabling translation](https://github.com/projectblacklight/spotlight/wiki/Translations) on the wiki.

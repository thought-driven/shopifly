# Shopifly

Shopifly is a command-line utility that helps to enforce branch-theme parity.

At this time it is compatible only with `config.yml` based Shopify Themekit
setups.

## Dependencies

Shopifly requires the `theme` command to be in your command line. See
[installation instructions](https://shopify.github.io/themekit/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shopifly'
```

And then execute:

    $ bundle

Or install it globally using:

    $ gem install shopifly

## Setup

Shopifly requires two local files: `config.stores.yml` and `.current_store`.

These files should both be added to your `.gitignore`.

### config.stores.yml

The `config.stores.yml` file tells it how to access the different stores you
own.

Sample Config:

```
# config.stores.yml

shared_config:
  deploy_command: "theme deploy"
  directory: ../shopify/
  ignore_files:
    - config/settings_data.json

stores:
  default: "dev"
  dev:
    password: xxx
    store: my-shop-dev.myshopify.com
  qa:
    password: xxx
    store: my-shop-staging.myshopify.com
  live
    password: xxx
    store: my-shop.myshopify.com
```

### .current_store

The `.current_store` file tells Shopifly which store you currently would like to
work with.

The `.current_store` file should just be a one-line file with the name of the
store from the `config.stores.yml` file that you'd currently like to work with.
You can easily upload the same theme to multiple stores by manipulating this
variable

For example, a possible value for the `config.stores.yml` file above would be:

```
dev
```

## Usage

Shopifly configures the local `config.yml` to point to a theme that corresponds
to the current branch name.

It uses a "find or create" algorithm, generating this theme if it does not exist.

Shopifly configures the `build`, `development` and `production` keys of your
`config.yml` to all point to this remote theme.

**Note** It is _always_ important to quit any running file watch processes (i.e.
`theme watch`) before switching branches.

### Create a new theme based on a new branch

    $ git checkout -b new-branch
    $ fly sync

    "Theme doesn't exist, creating..."
    "Setting config to point to new-branch, my-shop-dev.myshopify.com"
    "Uploading theme!"

### Configure your local environment to point to an existing theme

    $ git checkout master
    $ fly sync

    "Theme already exists: master, mack-weldon.myshopify.com"
    "Setting config to point to master, my-shop-dev.myshopify.com"

### Sync `settings_data.json` from the published theme to an existing theme

    $ git checkout existing-branch
    $ fly sync --with-settings

    "Downloading settings"
    ...
    "Uploading settings"

## Explanation

The `fly sync` command performs the following:

Assuming we're on a branch called `my-branch-theme`, and `.current_store` ==
`dev`

1. Checks if there exists a theme on the `dev` store named `my-branch-theme`.
2. If so, skips to step 5. If not:
3. Create a Shopify theme on the `dev` store named `my-branch-theme`.
4. Uploads the contents of your current branch to the theme using the
   `shared_config.deploy_command` from `config.stores.yml`.
5. If the theme did not previously exist or if the `--with-settings` flag is
   used, identifies the currently _published_ theme on your `.current_store` and
   copies the `settings_data.json` from the published theme to the `my-branch-theme`
   theme.
6. Sets your `config.yml` `build`, `development` and `production` keys to point
   to this new theme.

## Development

In this repo:

```
rake build
```

In another repo:

```
gem install --local ~/dev/lunchtime/shopifly/pkg/shopifly-X.X.X.gem
```

To install this gem onto your local machine and ruby version (found in
`.ruby-version`), run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## License

All rights reserved, Lunchtime Labs LLC, 2020

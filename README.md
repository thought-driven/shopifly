# Shopifly

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shopifly'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shopifly

## Usage

When I am at the command line inside of a Shopify theme repository

And I am on the master branch

And I type “fly branch my-branch-name”

Then the branch “my-branch-name” is created in git and checked out

And my Shopify shop has a new theme called “my-branch-name” which is a duplicate of the master branch

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shopifly.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

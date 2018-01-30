# Coruro Ruby

The Ruby version of [Coruro](../README.md). This README provides details for the ruby-specific Coruro implementation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coruro-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coruro-ruby

## Usage


```ruby
# Instantiate a Coruro instance. This also ensures Mailcatcher is running
coruro = Coruro.new(adapter: :mailcatcher)

# Load the emails mailcatcher caught to "your-fave@example.com"
messages_to_my_fave = coruro.where(to: /your-fave@example.com/)
# Since these are instances of a Mail object at the moment, which means they probably play nice with [EmailSpec::Matchers](https://github.com/email-spec/email-spec#rspec-matchers)
include EmailSpec::Matchers
messages_to_my_fave.each do
  assert_must deliver_to("your-fave@example.com")
end
```

### Tearing Down Mailcatcher
Because Coruro manages a local mailcatcher process, you may want to clean up *after* your test suite runs. Otherwise you may wind up with an orphaned Mailcatcher process. This isn't the end of the world, since Mailcatcher will refuse to start a second process if one is running already, but if you don't want it to stick around you can perform a post-suite cleanup. This is done by calling `#stop` on an instance of Coruro. See the following example for Minitest:

```ruby
Minitest.after_run do
  Coruro.new(adapter: :mailcatcher).stop
end
```
For those using Rspec, you will want to use the appropriate [`after` hook](https://relishapp.com/rspec/rspec-core/v/3-7/docs/hooks/before-and-after-hooks).

For Cucumber users, you will want want to use the [`at_exit` global hook](https://github.com/cucumber/cucumber/wiki/Hooks#global-hooks)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`. To release a new version, update the version number in `version.rb`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wecohere/coruro. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](../CODE_OF_CONDUCT.md). See [Our Contributing Guide](../CONTRIBUTING.md) for more details.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the coruro project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](../CODE_OF_CONDUCT.md).

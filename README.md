# Coruro
Coruro is a [capybara](https://github.com/teamcapybara/capybara)-inspired testing library for emails and similar messages. It is designed to allow querying messages your application sent while running outside of your application process. This makes it easier to parallelize tests and shrink test suite startup time.

Coruro depends on [Mailcatcher](https://github.com/sj26/mailcatcher), which acts as a fake SMTP server for mail delivery purposes. Additional adapters will come later.

## Features
* Query emails sent during a test run like any other API.
* Get a collection of messages or a single message back and make assertions.
* Manage Mailcatcher in your feature test suite without having to juggle processes.

## Usage
We currently only have a [Ruby](./coruro-ruby) implementation, but expect more languages as we build projects across more languages. Check your implementation's README for documentation:

* [Ruby](./coruro-ruby/README.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wecohere/coruro. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](./CODE_OF_CONDUCT.md). See [our contributing guide](./CONTRIBUTING.md) for more details.

## License

The library is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Coruro project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](./CODE_OF_CONDUCT.md).

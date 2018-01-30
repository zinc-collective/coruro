# Coruro
Coruro is a [capybara](https://github.com/teamcapybara/capybara)-inspired testing library emails and similar notifications. It is designed to allow querying of the messages your application sends without running within your application process. This makes tests much more parallelizable and shrinks test suite startup and time.

Currently, Coruro depends on [Mailcatcher](https://github.com/sj26/mailcatcher), which acts as a fake SMTP server for mail delivery purposes. Additional adapters will come later. Maybe because you wrote one!

We are currently only supporting [Ruby](./coruro-ruby), but expect more languages as we build projects across more languages.

## Features
* Query emails sent during a test run like any other API. Get a list or single object back that you can use to make some assertions.
* Manage Mailcatcher in your feature test suite without having to juggle processes.

## Contributing
Review our [CONTRIBUTING.md](./CONTRIBUTING.md) documentation.


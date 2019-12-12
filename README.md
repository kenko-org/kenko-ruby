# Kenko

Zero dependency library for adding [health checks](https://microservices.io/patterns/observability/health-check-api.html) to any rack based projects.

Supported features:

1. custom health endpoint;
2. html/json pages by defauld;
3. custom checks;
4. specify checks for the each middleware;

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kenko'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kenko

## Usage

### Base

Step 1: define custom checks

```ruby
require 'kenko'

Kenko::Container.register(:base) { :ok }
Kenko::Container.register(:database) { SQLConnection.execute }
Kenko::Container.register(:redis) { Redis.ping }
```

Step 2: add middleware

```ruby
require 'sinatra/base'
require 'kenko/middleware'

class Web < Sinatra::Base
  use Kenko::Middleware, checks: :all, path: '/health'

  get '/' do
    'index'
  end
end
```

Step 3: open `/health` or `/health.json` and see result

### Rails
SOON

### Hanami
SOON

### Sinatra
SOON

### Roda
SOON

## Development

Run `bundle install` and `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davydovanton/kenko. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kenko project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/davydovanton/kenko/blob/master/CODE_OF_CONDUCT.md).

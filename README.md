# Sentry

<p align="center">
  <a href="https://sentry.io/?utm_source=github&utm_medium=logo" target="_blank">
    <picture>
      <source srcset="https://sentry-brand.storage.googleapis.com/sentry-logo-white.png" media="(prefers-color-scheme: dark)" />
      <source srcset="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" media="(prefers-color-scheme: light), (prefers-color-scheme: no-preference)" />
      <img src="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" alt="Sentry" width="280">
    </picture>
  </a>
</p>

![CI](https://github.com/ifad/sentry-legacy-ruby/actions/workflows/ci.yml/badge.svg)

This is IFAD mirror of `sentry-ruby` gem with added support of legacy rubies (currently versions 2.3, 2.2 and 2.1).

## Considerations

Ruby 2.2 with Ubuntu-latest is not working due to sefmentaiton fault [https://github.com/ruby/setup-ruby/issues/496]

## Initializer

Create a `config/initializers/sentry.rb` with

```
require 'sentry-ruby'
require 'yaml'
Sentry.init do |config|
  config.dsn = YAML.load_file('config/sentry.yml')[Rails.env.to_s]['dsn']
  config.breadcrumbs_logger = [:sentry_logger, :http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    0.5
  end
end

class SentryMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env)
  rescue Exception => e # rubocop:disable Lint/RescueException
    Sentry.capture_exception(e)
    raise e
  end
end

Rails.configuration.middleware.use SentryMiddleware
```

## Capistrano task

```
namespace :sentry do
  desc '[internal] Creates the sentry.yml configuration file in shared path.'
  task :setup do
    run "mkdir -p #{shared_path}/config"
    put compile('sentry.yml.erb'), "#{shared_path}/config/sentry.yml"
  end
  after "deploy:setup", "deploy:sentry:setup"

  desc "[internal] Updates the local.rb settings symlink."
  task :symlink do
    source = "#{shared_path}/config/sentry.yml"
    run "test -f #{source} && ln -nfs #{source} #{release_path}/config/sentry.yml || true"
  end
  after "deploy:update_code", "deploy:sentry:symlink"
end
```

## Custom notifier

```
def notify_sentry(level, exception, options = {})
  Sentry.notify_exception(exception, options)
end
```
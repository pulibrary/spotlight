require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Internal
  class Application < Rails::Application
        # Logging
        if ENV["RAILS_LOG_TO_STDOUT"].present?
          config.log_level = :debug
          config.log_formatter = ::Logger::Formatter.new
          # log to stdout
          logger               = ActiveSupport::Logger.new(STDOUT)
          logger.formatter     = config.log_formatter
          config.logger        = ActiveSupport::TaggedLogging.new(logger)
          # Print deprecation notices to the Rails logger.
          config.active_support.deprecation = :log
          # Raise an error on page load if there are pending migrations.
          config.active_record.migration_error = :page_load
          # Highlight code that triggered database queries in logs.
          config.active_record.verbose_query_logs = true
        end
          config.action_mailer.default_url_options = { host: "localhost:3000", from: "noreply@example.com" }
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end

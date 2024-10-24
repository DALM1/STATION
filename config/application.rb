require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Epicht
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Load environment variables using dotenv for development and test environments.
    Dotenv::Rails.load if defined?(Dotenv::Rails)

    # Add other subdirectories in lib to autoload, ignoring unnecessary folders.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # Example:
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Autoload lib directory
    config.autoload_paths << Rails.root.join('lib')

    # Eager load paths if necessary, for production mode
    config.eager_load_paths << Rails.root.join('lib')
  end
end

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Railsgoat
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # RAILSGOAT SPECIFC CONFIGURATION
    # Disable changes to actve_record belongs_to which breaks associations in RailsGoat from 5 onwards
    config.active_record.belongs_to_required_by_default = false

    # Disable CSRF protection for RailsGoat
    config.action_controller.per_form_csrf_tokens = false

    # Configure the default encoding used in templates for Ruby 1.9.
    # config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    #config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # add app/assets/fonts to the asset path
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = "1.0"

    I18n.config.enforce_available_locales = false

    # config.action_dispatch.return_only_media_type_on_content_type = false
  end
end

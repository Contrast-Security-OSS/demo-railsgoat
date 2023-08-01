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
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # RAILSGOAT SPECIFC CONFIGURATION
    # Disable changes to actve_record belongs_to which breaks associations in RailsGoat from 5 onwards
    config.active_record.belongs_to_required_by_default = false

    # Disable CSRF protection for RailsGoat
    config.action_controller.per_form_csrf_tokens = false

    # config.action_dispatch.return_only_media_type_on_content_type = false
  end
end

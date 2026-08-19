require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# Note: ActiveRecord is intentionally not required — this app uses
# Mongoid (MongoDB) instead of the default SQL/ActiveRecord stack.

Bundler.require(*Rails.groups)

module UpscCompanion
  class Application < Rails::Application
    config.load_defaults 7.1

    # This is a pure JSON API — no views, no sessions, no cookies.
    config.api_only = true
  end
end

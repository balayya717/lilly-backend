Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.log_level = :info
  config.log_tags = [:request_id]

  # Log to STDOUT so `render logs` / the Render dashboard can show it.
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = Rails.application.config.log_formatter
  config.logger    = ActiveSupport::TaggedLogging.new(logger)

  # Render terminates SSL for you at the edge, so the app itself
  # doesn't need to force it — avoids redirect loops.
  config.force_ssl = false

  # Render's free web service gets a dynamic *.onrender.com hostname.
  # Clearing this avoids Rails' Host header protection blocking it.
  config.hosts.clear
end

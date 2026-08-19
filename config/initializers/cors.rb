Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Wide open for now since this is a personal-use v1 with no auth yet.
    # Once the app has real users/auth, tighten this to specific origins.
    origins "*"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options]
  end
end

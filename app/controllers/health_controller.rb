class HealthController < ApplicationController
  def show
    mongo_ok =
      begin
        Mongoid.default_client.database.command(ping: 1)
        true
      rescue StandardError
        false
      end

    render json: {
      status: mongo_ok ? "ok" : "degraded",
      database: mongo_ok ? "connected" : "unreachable",
      time: Time.current
    }
  end
end

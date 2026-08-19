class ApplicationController < ActionController::API
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render_not_found
  rescue_from Mongoid::Errors::Validations, with: :render_validation_error
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def render_not_found
    render json: { error: "Not found" }, status: :not_found
  end

  def render_validation_error(exception)
    render json: { errors: exception.document.errors.full_messages }, status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end

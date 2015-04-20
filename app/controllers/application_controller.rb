class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  protected

  def record_not_found
    render json: { message: 'page not found' }, status: :not_found
  end

  def unpermitted_parameters(error)
    render json: { message: error.message }, status: :unprocessable_entity
  end
end

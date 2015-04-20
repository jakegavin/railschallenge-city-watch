class ErrorsController < ApplicationController
  def catch_404
    render json: { message: 'page not found' }, status: :not_found
  end
end

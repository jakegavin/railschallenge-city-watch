class RespondersController < ApplicationController
  def index
    responders = Responder.all
    if params[:show] == 'capacity'
      responder_capacity = ResponderCapacity.new(responders)
      render json: { capacity: responder_capacity }
    else
      render json: { responders: responders }
    end
  end

  def show
    responder = Responder.find_by!(name: params[:id])
    render json: { responder: responder }
  end

  def create
    params[:responder][:type].try(:downcase!)
    responder = Responder.new(responder_params)
    if responder.save
      render json: { responder: responder }, status: :created
    else
      render json: { message: responder.errors }, status: :unprocessable_entity
    end
  end

  def update
    responder = Responder.find_by!(name: params[:id])
    responder.update(responder_params)
    render json: { responder: responder }
  end

  private

  def responder_params
    case action_name
    when 'create'
      params.require(:responder).permit(:capacity, :name, :type)
    when 'update'
      params.require(:responder).permit(:on_duty)
    end
  end
end

class EmergenciesController < ApplicationController
  def index
    emergencies = Emergency.all
    full_response_count = [
      emergencies.select(&:full_response?).count,
      emergencies.count
    ]
    render json: { emergencies: emergencies, full_responses: full_response_count  }
  end

  def show
    emergency = Emergency.find_by!(code: params[:id])
    render json: { emergency: emergency }
  end

  def create
    emergency = Emergency.new(emergency_params)
    if emergency.save
      render json: { emergency: emergency }, status: :created
    else
      render json: { message: emergency.errors }, status: :unprocessable_entity
    end
  end

  def update
    emergency = Emergency.find_by!(code: params[:id])
    emergency.update(emergency_params)
    render json: { emergency: emergency }
  end

  private

  def emergency_params
    case action_name
    when 'create'
      params.require(:emergency).permit(:code, :fire_severity, :medical_severity, :police_severity)
    when 'update'
      params.require(:emergency).permit(:fire_severity, :medical_severity, :police_severity, :resolved_at)
    end
  end
end

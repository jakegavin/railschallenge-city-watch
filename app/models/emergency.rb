class Emergency < ActiveRecord::Base
  has_many :responders

  validates :code, presence: true, uniqueness: true
  validates :fire_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :police_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :medical_severity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :dispatch_responders!

  def as_json(*)
    {
      code: code,
      resolved_at: resolved_at,
      fire_severity: fire_severity,
      police_severity: police_severity,
      medical_severity: medical_severity,
      responders: responders.map(&:name),
      full_response: full_response?
    }
  end

  def full_response?
    if resolved_at.present?
      resolved_full_response.nil? ? calculate_full_response : resolved_full_response
    else
      calculate_full_response
    end
  end

  private

  def dispatch_responders!
    Dispatcher.new(self).dispatch!
    Dispatcher.new(self).resolve!
  end

  def calculate_full_response
    Responder::TYPES.all? do |type|
      severity = send("#{type}_severity")
      responder_capacity = responders.send("#{type}").sum(:capacity)
      severity - responder_capacity == 0
    end
  end
end

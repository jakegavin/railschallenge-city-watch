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

  private

  def full_response?
    Responder::TYPES.all? do |type|
      severity = send("#{type}_severity")
      responder_capacity = responders.send("#{type}").sum(:capacity)
      severity - responder_capacity == 0
    end
  end

  def dispatch_responders!
    Dispatcher.new(self).dispatch!
  end
end

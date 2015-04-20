class Responder < ActiveRecord::Base
  self.inheritance_column = nil

  enum type: { fire: 0, police: 1, medical: 2 }

  validates :name, presence: true, uniqueness: true
  validates :type, presence: true
  validates :capacity, presence: true, inclusion: 1..5

  def as_json(*)
    {
      emergency_code: emergency_code,
      type: type.try(:titleize),
      name: name,
      capacity: capacity,
      on_duty: on_duty
    }
  end
end

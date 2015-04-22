class Responder < ActiveRecord::Base
  TYPES = [:fire, :police, :medical]
  self.inheritance_column = nil

  enum type: TYPES

  validates :name, presence: true, uniqueness: true
  validates :type, presence: true
  validates :capacity, presence: true, inclusion: 1..5

  scope :on_duty, -> { where(on_duty: true) }

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

class Dispatcher
  attr_reader :emergency

  def initialize(emergency)
    @emergency = emergency
  end

  def dispatch!
    Responder::TYPES.each do |type|
      send("dispatch_#{type}_responders")
    end
  end

  def resolve!
    emergency.update_columns(resolved_full_response: emergency.full_response?) if emergency.resolved_at.present?
    emergency.responders.update_all(emergency_id: nil) if emergency.resolved_at.present?
  end

  Responder::TYPES.each do |type|
    define_method("dispatch_#{type}_responders") do
      emergency_type_severity = emergency.send("#{type}_severity")
      return nil if emergency_type_severity == 0
      perfect_responder = Responder.on_duty.send(type).where(capacity: emergency_type_severity)
      if perfect_responder.present?
        emergency.responders << perfect_responder.take
      else
        qualified_responders = Responder.send(type).on_duty.available.order('capacity DESC')
        assign_these_responders = []
        qualified_responders.each do |responder|
          if assign_these_responders.sum(&:capacity) < emergency_type_severity
            assign_these_responders << responder
          end
        end
        emergency.responders << assign_these_responders
      end
    end
  end
end

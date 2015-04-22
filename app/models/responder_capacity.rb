class ResponderCapacity
  attr_reader :responders

  def initialize(responders)
    @responders = responders
  end

  def as_json(*)
    Responder::TYPES.each_with_object({}) do |type, hash|
      hash[type.to_s.titleize] = send("#{type}_capacity")
    end
  end

  Responder::TYPES.each do |type|
    define_method("#{type}_capacity") do
      capacity_array = []
      capacity_array << responders.send(type).map(&:capacity).sum
      capacity_array << responders.send(type).map(&:capacity).sum
      capacity_array << responders.send(type).on_duty.map(&:capacity).sum
      capacity_array << responders.send(type).on_duty.map(&:capacity).sum
      capacity_array
    end
  end
end

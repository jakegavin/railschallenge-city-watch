class FullResponseCount
  attr_reader :emergencies

  def initialize(emergencies)
    @emergencies = emergencies
  end

  def as_json(*)
    [full_response_count, emergencies.count]
  end

  private

  def full_response_count
    emergencies.select(&:full_response?).count
  end
end

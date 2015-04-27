class AddResolvedFullResponseToEmergencies < ActiveRecord::Migration
  def change
    add_column :emergencies, :resolved_full_response, :boolean
  end
end

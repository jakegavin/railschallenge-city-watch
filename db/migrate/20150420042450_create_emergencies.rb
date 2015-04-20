class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.string :code
      t.datetime :resolved_at
      t.integer :fire_severity
      t.integer :police_severity
      t.integer :medical_severity
    end
  end
end

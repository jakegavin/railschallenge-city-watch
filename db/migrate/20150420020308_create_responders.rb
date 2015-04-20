class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.string :name
      t.integer :type
      t.boolean :on_duty, default: false
      t.integer :capacity
      t.string :emergency_code
    end
  end
end

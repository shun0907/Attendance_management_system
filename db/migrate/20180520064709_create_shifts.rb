class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.integer :user_id
      t.date :date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end

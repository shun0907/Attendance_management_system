class ChangeDatatypeEndTimeOfShift < ActiveRecord::Migration[5.0]
  def change
    change_column :shifts, :end_time, :string
  end
end

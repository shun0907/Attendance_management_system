class AddBesicWorkHoursToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :besic_work_hours, :string
  end
end

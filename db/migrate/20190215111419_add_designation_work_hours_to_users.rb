class AddDesignationWorkHoursToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :designation_work_hours, :string
  end
end

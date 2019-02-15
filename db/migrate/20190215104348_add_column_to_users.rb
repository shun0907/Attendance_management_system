class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :affiliation, :string, :after => :email
  end
end

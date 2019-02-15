class AddColumnAffiliationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :affiliation, :string
  end
end

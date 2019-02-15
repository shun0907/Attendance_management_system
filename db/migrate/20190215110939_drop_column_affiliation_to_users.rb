class DropColumnAffiliationToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :Affiliation, :string
  end
end

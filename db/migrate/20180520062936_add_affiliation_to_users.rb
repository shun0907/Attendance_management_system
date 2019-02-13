class AddAffiliationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :Affiliation, :string
  end
end

class AddIndexToClients < ActiveRecord::Migration
  def change
    add_column :clients, :category, :string
    add_index :clients, :category
  end
end

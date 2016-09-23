class AddNameIndexToClients < ActiveRecord::Migration
  def change
    add_index :clients, :name
  end
end

class AddAddyIndexToClients < ActiveRecord::Migration
  def change
    add_index :clients, :address, :unique => true
  end
end

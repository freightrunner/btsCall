class AddAddressIndexToClients < ActiveRecord::Migration
  def change
    add_index :clients, [:name, :address], :unique => true
  end
end

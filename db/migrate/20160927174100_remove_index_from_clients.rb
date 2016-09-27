class RemoveIndexFromClients < ActiveRecord::Migration
  def change
    remove_index :clients, [:name, :address]
  end
end

class FixTypeName < ActiveRecord::Migration
  def change
    rename_column :clients, :type, :status
  end
end

class ChangeDefaultColumnValuesInClients < ActiveRecord::Migration
  def change
    change_column_default(:clients, :revenue, 0)
    change_column_default(:clients, :main_phone, "000-000-0000")
    change_column_default(:clients, :email_domain, "@.com")
  end
end

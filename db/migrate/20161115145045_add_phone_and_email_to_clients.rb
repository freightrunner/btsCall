class AddPhoneAndEmailToClients < ActiveRecord::Migration
  def change
    add_column :clients, :main_phone, :string
    add_column :clients, :email_domain, :string
    add_column :clients, :revenue, :decimal
  end
end

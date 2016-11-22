class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :phone_ext
      t.string :cell_number
      t.string :email
      t.string :title
      t.references :client, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

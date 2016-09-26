class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :comment, null: false
      t.references :client, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

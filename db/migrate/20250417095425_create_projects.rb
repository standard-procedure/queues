class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, default: "", null: false
      t.integer :status, default: 0, null: false
      t.belongs_to :owner, foreign_key: {to_table: "users"}
      t.timestamps
    end
  end
end

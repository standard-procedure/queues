class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.belongs_to :project, foreign_key: true
      t.string :title, default: "", null: false
      t.integer :position, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end

    add_index :cards, [:project_id, :status, :position]
  end
end

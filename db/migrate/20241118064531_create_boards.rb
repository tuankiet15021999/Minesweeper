class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :name
      t.integer :width
      t.integer :height
      t.integer :num_of_mines
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateExpendables < ActiveRecord::Migration[5.2]
  def change
    create_table :expendables do |t|
      t.string :image
      t.string :name, null: false
      t.string :url, null: false
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end

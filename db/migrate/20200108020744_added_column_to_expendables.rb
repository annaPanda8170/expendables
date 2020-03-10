class AddColumnToExpendables < ActiveRecord::Migration[5.2]
  def change
    add_column :expendables, :lastBuy, :timestamp
  end
end

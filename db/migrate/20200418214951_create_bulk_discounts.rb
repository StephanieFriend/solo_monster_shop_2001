class CreateBulkDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_discounts do |t|
      t.integer :percentage
      t.integer :quantity
    end
  end
end

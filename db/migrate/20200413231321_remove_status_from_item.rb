class RemoveStatusFromItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :status, :string
  end
end

class ChangeImageInItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image, :string, default: "https://www.intemposoftware.com/uploads/blog/Blog_inventory_control.jpg"
  end
end

require 'rails_helper'

RSpec.describe "Merchant Items Index Page", type: :feature do
  describe "When I visit the merchant items page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @regina = User.create({name: "Regina",
                           street_address: "6667 Evil Ln",
                           city: "Storybrooke",
                           state: "ME",
                           zip_code: "00435",
                           email_address: "evilqueen@example.com",
                           password: "henry2004",
                           password_confirmation: "henry2004",
                           role: 1,
                           merchant_id: @meg.id
                          })

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      @order_1 = Order.create({name: "Bob", address: "22 dog st", city: "Fort Collins",
                          state: "CO", zip: "80375", status: "Pending", user_id: @regina.id})
      @item_order_1 =  @order_1.item_orders.create!({
                                                      item: @tire,
                                                      quantity: 3,
                                                      price: @tire.price
                                                      })
      @item_order_2 =  @order_1.item_orders.create!({
                                                      item: @shifter,
                                                      quantity: 5,
                                                      price: @shifter.price
                                                      })

      visit '/'

      click_link 'Log in'

      fill_in :email_address, with: 'evilqueen@example.com'
      fill_in :password, with: 'henry2004'
      click_button 'Log in'
    end

    it 'I can click an edit item button to update the item info' do
      visit "/merchant"
      click_link 'View My Items'
      within("#item-#{@tire.id}") do
        click_link "Edit this Item"
      end

      expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")
      fill_in :name, with: "Helmet"
      fill_in :price, with: 20
      fill_in :description, with: "Protect your head"
      fill_in :image, with: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/HNNN2?wid=1144&hei=1144&fmt=jpeg&qlt=95&op_usm=0.5%2C0.5&.v=1570147746237"
      fill_in :inventory, with: 25
      click_button "Update Item"


      expect(current_path).to eq("/merchant/#{@meg.id}/items")
      expect(page).to have_content("Your item 'Helmet' has been updated")
      within("#item-#{@tire.id}") do
        expect(page).to have_content("Helmet")
        expect(page).to have_content("$20.00")
        expect(page).to have_css("img[src*='https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/HNNN2?wid=1144&hei=1144&fmt=jpeg&qlt=95&op_usm=0.5%2C0.5&.v=1570147746237']")
        expect(page).to_not have_content("Gatorskins")
        expect(page).to have_content("Active")
      end
    end

    it "cannot update item if data is incorrect or missing" do
      visit "/merchant"
      click_link 'View My Items'
      within("#item-#{@tire.id}") do
        click_link "Edit this Item"
      end

      fill_in :name, with: ""
      fill_in :price, with: -20
      fill_in :description, with: ""
      fill_in :inventory, with: ""
      click_button "Update Item"

      expect(page).to have_content("Name can't be blank, Description can't be blank, Inventory can't be blank, Inventory is not a number, and Price must be greater than or equal to 0")
      expect(page).to have_selector("input[value='-20']")
      expect(page).to have_button("Update Item")
    end
  end
end

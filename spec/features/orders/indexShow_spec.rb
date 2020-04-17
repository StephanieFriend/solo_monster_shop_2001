require 'rails_helper'

RSpec.describe("Orders index and show pages") do

    before(:each) do
      @user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                           state: "CO", zip_code: "80375", email_address: "bob@example.com",
                           password: "password1", password_confirmation: "password1", role: 0
                          })
      visit '/login'
      fill_in :email_address, with: "bob@example.com"
      fill_in :password, with: "password1"
      within ("#login-form") do
        click_on "Log in"
      end

       @order_1 = Order.create({name: "Bob", address: "22 dog st", city: "Fort Collins",
                           state: "CO", zip: "80375", status: "Pending", user_id: @user.id})
       @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
       @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
       @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

       @item_order_1 =  @order_1.item_orders.create!({
                                                       item: @tire,
                                                       quantity: 3,
                                                       price: @tire.price
                                                       })
       end

    it "can see link from profile page if there are orders" do
      visit '/user/profile'
      click_on "My Orders"
      expect(current_path).to eq("/user/profile/orders")
    end

    it "can see order info on my orders index page" do
      visit "/user/profile/orders"
      within("##{@order_1.id}") do
        expect(page).to have_link("#{@order_1.id}")
        expect(page).to have_content("Date ordered: #{@order_1.created_at}")
        expect(page).to have_content("Date updated: #{@order_1.updated_at}")
        expect(page).to have_content("Current Status: #{@order_1.status}")
        expect(page).to have_content("Number of Items: #{@order_1.items.sum(:quantity)}")
        expect(page).to have_content("Grand Total: $#{@order_1.grandtotal}")
      end
    end

    it "can see an order's show page" do
      visit "/user/profile/orders"
      within("##{@order_1.id}") do
        click_link("#{@order_1.id}")
      end
      expect(current_path).to eq("/profile/orders/#{@order_1.id}")

      within("#orderid") do
        expect(page).to have_content(@order_1.id)
      end
      within("#datecreated") do
        expect(page).to have_content(@order_1.created_at)
      end
      within("#dateupdated") do
        expect(page).to have_content(@order_1.updated_at)
      end
      expect(page).to have_content("Order Status: #{@order_1.status}")


      within("#item-#{@tire.id}") do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_css("img[src='https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588']")
        expect(page).to have_content(@item_order_1.quantity)
        expect(page).to have_content(@tire.price)
        expect(page).to have_content(@item_order_1.subtotal)

        expect(page).to_not have_content(@chain.name)
      end

      within ("#grandtotal") do
        expect(page).to have_content(@order_1.items.count)
        expect(page).to have_content("Total: $#{@order_1.grandtotal}")
      end
    end

    it "can cancel an order" do
      @meg_employee = User.create({name: "Regina",
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
      click_on "Log out"
      visit '/'
      click_on "Log in"
      fill_in :email_address, with: "evilqueen@example.com"
      fill_in :password, with: "henry2004"
      click_button "Log in"
      click_on "Order ##{@order_1.id}"
      click_on "Fulfill"
      @tire.reload

      visit "/profile/orders/#{@order_1.id}"
      expect(@tire.inventory).to eq(9)
      expect(page).to have_link("Cancel Order")
      click_link("Cancel Order")
      @order_1.reload
      @tire.reload
      expect(@item_order_1.fulfilled?).to eq(false)
      expect(@tire.inventory).to eq(12)

      expect(current_path).to eq("/user/profile")
      expect(page).to have_content("Order ##{@order_1.id} has been cancelled")
      expect(@order_1.status).to eq("Cancelled")

      visit "/profile/orders/#{@order_1.id}"
      expect(page).to have_content("Unfulfilled")
    end

end

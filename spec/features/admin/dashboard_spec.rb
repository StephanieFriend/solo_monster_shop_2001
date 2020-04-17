require 'rails_helper'

RSpec.describe 'As an admin employee' do
  before(:each) do
    @user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "bob@example.com",
                         password: "password1", password_confirmation: "password1", role: 0
                        })
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @admin = User.create({name: "Regina",
      street_address: "6667 Evil Ln",
      city: "Storybrooke",
      state: "ME",
      zip_code: "00435",
      email_address: "evilqueen@example.com",
      password: "henry2004",
      password_confirmation: "henry2004",
      role: 2,
      })
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    @order_1 = Order.create!(name: 'Regina', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "Pending", user_id: @user.id)
    @order_2 = Order.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: "Packaged", user_id: @user.id)
    @order_3 = Order.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: "Cancelled", user_id: @user.id)
    @order_4 = Order.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: "Shipped", user_id: @user.id)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

    visit '/'

    click_on 'Log in'
    fill_in :email_address, with: 'evilqueen@example.com'
    fill_in :password, with: 'henry2004'
    click_button 'Log in'
  end

  describe "I can visit my admin dashboard" do
    it "can see all orders in the system including the user who placed the order, order id, date the order was created, and the status" do
      expect(current_path).to eq('/admin')

      within("#order-#{@order_1.id}") do
        expect(page).to have_link(@order_1.user.name)
        expect(page).to have_content(@order_1.id)
        expect(page).to have_content(@order_1.created_at)
        expect(page).to have_content(@order_1.status)
        click_link(@order_1.user.name)
      end

      expect(current_path).to eq("/admin/users/#{@user.id}")
      visit '/admin'

      within("#order-#{@order_2.id}") do
        expect(page).to have_link(@order_2.user.name)
        expect(page).to have_content(@order_2.id)
        expect(page).to have_content(@order_2.created_at)
        expect(page).to have_content(@order_2.status)
      end

      within("#order-#{@order_3.id}") do
        expect(page).to have_link(@order_3.user.name)
        expect(page).to have_content(@order_3.id)
        expect(page).to have_content(@order_3.created_at)
        expect(page).to have_content(@order_3.status)
      end

      within("#order-#{@order_4.id}") do
        expect(page).to have_link(@order_4.user.name)
        expect(page).to have_content(@order_4.id)
        expect(page).to have_content(@order_4.created_at)
        expect(page).to have_content(@order_4.status)
      end

      expect("Packaged").to appear_before("Pending")
      expect("Pending").to appear_before("Shipped")
      expect("Shipped").to appear_before("Cancelled")
      expect("Cancelled").to_not appear_before("Packaged")
    end

    it 'Can ship orders packaged and ready to ship. Order status changes to shipped and user can no longer cancel order' do
      within("#order-#{@order_2.id}") do
        expect(page).to have_button('Ship')
        click_button('Ship')
        @order_2.reload
        expect(@order_2.status).to eq('Shipped')
      end

      within("#order-#{@order_1.id}") do
        expect(page).to_not have_button('Ship')
      end

      click_link 'Log out'
      click_link 'Log in'
      fill_in :email_address, with: @user.email_address
      fill_in :password, with: @user.password
      click_button 'Log in'

      @order_2.reload
      click_link 'My Orders'
      click_link "Order ##{@order_2.id}"
      expect(page).to_not have_link("Cancel Order")

      click_link 'Profile'
      click_link 'My Orders'
      click_link "Order ##{@order_1.id}"
      expect(page).to have_link("Cancel Order")
    end

    it "can click on an order id on the dashboard and go to admin only view of that orders show page" do
      visit "/admin"
      expect(page).to have_link("#{@order_2.id}")
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_link("#{@order_3.id}")
      expect(page).to have_link("#{@order_4.id}")
      click_on("#{@order_2.id}")
      expect(current_path).to eq("/admin/users/#{@user.id}/orders/#{@order_2.id}")
    end

  end
end

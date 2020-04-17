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

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 1)

    visit '/'

    click_on 'Log in'
    fill_in :email_address, with: 'evilqueen@example.com'
    fill_in :password, with: 'henry2004'
    click_button 'Log in'
  end

  it "can visit an orders show page and see order information" do
    visit '/admin'
    click_on("#{@order_1.id}")
    expect(current_path).to eq("/admin/users/#{@user.id}/orders/#{@order_1.id}")
    expect(page).to have_content(@order_1.id)
    expect(page).to have_content(@order_1.created_at)
    expect(page).to have_content(@order_1.updated_at)
    expect(page).to have_content(@order_1.status)
    within "##{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_content(2)
      expect(page).to have_content(@tire.price)
      expect(page).to have_content( "$200")
    end
    within "##{@pull_toy.id}" do
      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content(@pull_toy.description)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to have_content(3)
      expect(page).to have_content(@pull_toy.price)
      expect(page).to have_content("$30")
    end
    within "##{@dog_bone.id}" do
      expect(page).to have_content(@dog_bone.name)
      expect(page).to have_content(@dog_bone.description)
      expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      expect(page).to have_content(1)
      expect(page).to have_content(@dog_bone.price)
      expect(page).to have_content("$20")
    end
    expect(page).to have_content("Total Quantity: 6")
    expect(page).to have_content("Grand Total: $250")
  end

  it "can cancel an order" do
    visit "/admin/users/#{@user.id}/orders/#{@order_1.id}"
    expect(page).to have_link("Cancel Order")
    click_on("Cancel Order")
    @tire.reload
    expect(@tire.inventory).to eq(12)
    expect(@pull_toy.inventory).to eq(32)
    expect(@dog_bone.inventory).to eq(21)
    expect(current_path).to eq("/admin")
    within "#order-#{@order_1.id}" do
      expect(page).to have_content("Cancelled")
    end
  end

end

require 'rails_helper'

RSpec.describe 'As an admin employee' do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @regina = User.create({name: "Regina",
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
    @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    @order_1 = Order.create!(name: 'Regina', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "Pending", user_id: @regina.id)
    @order_2 = Order.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: "Pending", user_id: @regina.id)
    @order_3 = Order.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: "cancelled", user_id: @regina.id)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 3)

    @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

    visit '/'

    click_on 'Log in'
    fill_in :email_address, with: 'evilqueen@example.com'
    fill_in :password, with: 'henry2004'
    click_button 'Log in'
  end

  it "can see a merchants dashboard as an admin" do
    visit '/merchants'
    click_on "#{@meg.name}"
    expect(current_path).to eq("/admin/merchants/#{@meg.id}")
    expect(page).to have_content(@meg.name)
    expect(page).to have_content(@meg.address)
    expect(page).to have_content(@meg.city)
    expect(page).to have_content(@meg.state)
    expect(page).to have_content(@meg.zip)
    within("##{@order_1.id}") do
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(5)
      expect(page).to have_content(230)
    end
    within("##{@order_2.id}") do
      expect(page).to have_content(@order_2.created_at)
      expect(page).to have_content(3)
      expect(page).to have_content(30)
    end
  end
end

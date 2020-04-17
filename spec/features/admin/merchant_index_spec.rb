require 'rails_helper'

RSpec.describe 'As an admin user I can visit the merchant index page' do
  it "I can see all merchants in the system with name, city, state, and enable/disable button" do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203, active?:false)

    @regina = User.create({name: "Regina",
                          street_address: "6667 Evil Ln",
                          city: "Storybrooke",
                          state: "ME",
                          zip_code: "00435",
                          email_address: "evilqueen@example.com",
                          password: "henry2004",
                          password_confirmation: "henry2004",
                          role: 2,
                          merchant_id: @meg.id
                         })

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    visit '/'

    click_on 'Log in'
    fill_in :email_address, with: 'evilqueen@example.com'
    fill_in :password, with: 'henry2004'
    click_button 'Log in'
    visit '/admin/merchants'

    within "#merch-shop-#{@brian.id}" do
      expect(page).to have_link(@brian.name)
      expect(page).to have_content(@brian.city)
      expect(page).to have_content(@brian.state)
      expect(page).to have_no_button('disable')
      expect(page).to have_button('enable')
      click_link @brian.name
    end

    expect(current_path).to eq("/admin/merchants/#{@brian.id}")
    visit '/admin/merchants'

    within "#merch-shop-#{@meg.id}" do
      expect(page).to have_link(@meg.name)
      expect(page).to have_content(@meg.city)
      expect(page).to have_content(@meg.state)
      expect(page).to have_no_button('enable')
      expect(page).to have_button('disable')
    end
  end
end

# User Story 52, Admin Merchant Index Page
#
# As an admin user
# When I visit the merchant's index page at "/admin/merchants"
# I see all merchants in the system
# Next to each merchant's name I see their city and state
# The merchant's name is a link to their Merchant Dashboard at routes such as "/admin/merchants/5"
# I see a "disable" button next to any merchants who are not yet disabled
# I see an "enable" button next to any merchants whose accounts are disabled

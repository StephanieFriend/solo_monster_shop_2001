require 'rails_helper'

RSpec.describe 'As an admin' do
  describe 'When I visit the admin merchant page' do
    before(:each) do
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
                             merchant_id: @brian.id
                            })

      @tire = @brian.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", active?:false, inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", active?:false, inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      visit '/'

      click_on 'Log in'
      fill_in :email_address, with: 'evilqueen@example.com'
      fill_in :password, with: 'henry2004'
      click_button 'Log in'
    end

    it 'I see an enable button next to the disabled merchants' do

      visit '/admin/merchants'

      within "#merch-shop-#{@brian.id}" do
        expect(page).to have_button('enable')
      end

      within "#merch-shop-#{@meg.id}" do
        expect(page).to have_no_button('enable')
      end
    end

    it 'When I click on enable I see a flash message and am routed back to admin/merchants' do

      visit '/admin/merchants'

      within "#merch-shop-#{@brian.id}" do
        click_button 'enable'
      end

      expect(current_path).to eq('/admin/merchants')
      expect(page).to have_content("#{@brian.name}'s account is now enabled")
    end

    it 'When I click enable all merchants items will also be enabled' do

      visit "/merchants/#{@brian.id}/items"

      within "#item-#{@tire.id}" do
        expect(@tire.active?).to be_falsey
      end

      within "#item-#{@pull_toy.id}" do
        expect(@pull_toy.active?).to be_falsey
      end

      within "#item-#{@dog_bone.id}" do
        expect(@dog_bone.active?).to be_falsey
      end

      visit '/admin/merchants'

      within "#merch-shop-#{@brian.id}" do
        click_button 'enable'
      end

      visit "/merchants/#{@brian.id}/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content('Active')
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_content('Active')
      end

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_content('Active')
      end
    end
  end
end

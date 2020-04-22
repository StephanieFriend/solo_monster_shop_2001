require 'rails_helper'

RSpec.describe 'As a user' do
  describe 'when I visit my cart' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop",
                             address: '123 Bike Rd.',
                             city: 'Denver',
                             state: 'CO',
                             zip: 80203)
      @mike = Merchant.create(name: "Mike's Print Shop",
                              address: '123 Paper Rd.',
                              city: 'Denver',
                              state: 'CO',
                              zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins",
                                description: "They'll never pop!",
                                price: 100,
                                image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588",
                                inventory: 30)
      @chain = @meg.items.create(name: "Chain",
                                 description: "It'll never break!",
                                 price: 50,
                                 image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588",
                                 inventory: 50)
      @paper = @mike.items.create(name: "Lined Paper",
                                  description: "Great for writing on!",
                                  price: 20,
                                  image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png",
                                  inventory: 25)

      @discount1 = @meg.bulk_discounts.create(percentage: 10,
                                              quantity: 9)
      @discount2 = @meg.bulk_discounts.create(percentage: 5,
                                              quantity: 7)

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

      visit '/'
      click_link 'Log in'
      fill_in :email_address, with: @regina.email_address
      fill_in :password, with: @regina.password
      click_button 'Log in'
    end

    it 'When I reach a certain item quantity in my cart I receive a discount on that item' do
      visit "/items/#{@tire.id}"
      click_button "Add To Cart"

      visit '/cart'

      within "#cart-item-#{@tire.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        expect(page).to have_content(6)
        expect(page).to have_content("$#{6 * @tire.price}")
        click_button "+"
        expect(page).to have_content(7)
        expect(page).to have_content("$665.00")
      end
    end

    it 'When I decrease my item quantity under the discount qualifications the price goes back to the original price' do
      visit "/items/#{@tire.id}"
      click_button "Add To Cart"

      visit '/cart'

      within "#cart-item-#{@tire.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        expect(page).to have_content(6)
        expect(page).to have_content("$#{6 * @tire.price}")
        click_button "+"
        expect(page).to have_content(7)
        expect(page).to have_content("$665.00")
        click_button "-"
        expect(page).to have_content(6)
        expect(page).to have_content("$#{6 * @tire.price}")
      end
    end

    it 'When I increase one item to qualify for a discount it does not apply to another item' do
      visit "/items/#{@tire.id}"
      click_button "Add To Cart"

      visit '/cart'

      within "#cart-item-#{@tire.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        expect(page).to have_content(6)
        expect(page).to have_content("$#{6 * @tire.price}")
        click_button "+"
        expect(page).to have_content(7)
        expect(page).to have_content("$665.00")
      end

      visit "/items/#{@chain.id}"
      click_button "Add To Cart"

      visit '/cart'

      within "#cart-item-#{@chain.id}" do
        expect(page).to have_content("$#{@chain.price}")
      end
    end

    it 'When I qualify for two discounts it takes the larger of the two' do
      visit "/items/#{@tire.id}"
      click_button "Add To Cart"

      visit '/cart'

      within "#cart-item-#{@tire.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        expect(page).to have_content(6)
        expect(page).to have_content("$#{6 * @tire.price}")
        click_button "+"
        expect(page).to have_content(7)
        expect(page).to have_content("$665.00")
        click_button "+"
        click_button "+"
        expect(page).to have_content(9)
        expect(page).to have_content("$810.00")
        expect(page).to have_no_content("$855.00")
      end
    end

    it 'A discount cannot apply to other merchants items' do
      visit "/items/#{@paper.id}"
      click_button "Add To Cart"

      visit '/cart'

      within "#cart-item-#{@paper.id}" do
        expect(page).to have_content("$#{@paper.price}")
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        expect(page).to have_content(7)
        expect(page).to have_content("$#{@paper.price}")
      end
    end
  end
end
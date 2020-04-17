require 'rails_helper'

RSpec.describe 'As a visitor' do
  it 'I see top 5 most popular items on the item index page' do
    @user = User.create({name: "Regina",
                         street_address: "6667 Evil Ln",
                         city: "Storybrooke",
                         state: "ME",
                         zip_code: "00435",
                         email_address: "evilqueen@example.com",
                         password: "henry2004",
                         password_confirmation: "henry2004",
                         role: 0
                        })
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    @pens = @mike.items.create(name: "Pens", description: "You can write on paper with it!", price: 5, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 10)
    @gloves = @meg.items.create(name: "Gloves", description: "It's a glove!!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 40)
    @chains = @meg.items.create(name: "Chains", description: "It's a chain!", price: 9, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 23)
    @leggings = @meg.items.create(name: "Leggings", description: "It's a legging!", price: 30, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 59)
    @index_cards = @mike.items.create(name: "Index Cars", description: "It's an index card!", price: 83, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 9)
    @folders = @mike.items.create(name: "Folders", description: "It's a folder!", price: 8, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 19)
    @helmet = @meg.items.create(name: "Helment", description: "It's a helmet!", price: 12, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 62)

    visit '/'

    click_link 'Log in'

    fill_in :email_address, with: 'evilqueen@example.com'
    fill_in :password, with: 'henry2004'
    click_button 'Log in'

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    visit "/items/#{@pens.id}"
    click_on "Add To Cart"
    visit "/items/#{@gloves.id}"
    click_on "Add To Cart"
    visit "/items/#{@chains.id}"
    click_on "Add To Cart"
    visit "/items/#{@leggings.id}"
    click_on "Add To Cart"
    visit "/items/#{@index_cards.id}"
    click_on "Add To Cart"
    visit "/items/#{@folders.id}"
    click_on "Add To Cart"
    visit "/items/#{@helmet.id}"
    click_on "Add To Cart"
    @items_in_cart = [@paper,@tire,@pencil,@pens,@gloves,@chains,@leggings,@index_cards,@folders,@helmet]

    visit '/cart'

    within "#cart-item-#{@tire.id}" do
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to have_content(4)
    end

    within "#cart-item-#{@paper.id}" do
      click_button "+"
      expect(page).to have_content(2)
    end

    within "#cart-item-#{@pencil.id}" do
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to have_content(7)
    end

    within "#cart-item-#{@pens.id}" do
      expect(page).to have_content(1)
    end

    within "#cart-item-#{@gloves.id}" do
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to have_content(12)
    end

    within "#cart-item-#{@chains.id}" do
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to have_content(5)
    end

    within "#cart-item-#{@leggings.id}" do
      click_button "+"
      click_button "+"
      expect(page).to have_content(3)
    end

    within "#cart-item-#{@index_cards.id}" do
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to have_content(8)
    end

    within "#cart-item-#{@folders.id}" do
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to have_content(6)
    end

    within "#cart-item-#{@helmet.id}" do
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to have_content(9)
    end

    click_on 'Checkout'

    fill_in :name, with: @user.name
    fill_in :address, with: @user.street_address
    fill_in :city, with: @user.city
    fill_in :state, with: @user.state
    fill_in :zip, with: @user.zip_code

    click_button "Create Order"

    visit '/items'

    expect(page).to have_content("Most Popular")
    expect(page).to have_content("Least Popular")

    within '.least-popular' do
      expect(page).to have_content(@leggings.name)
      expect(page).to have_content(@pens.name)
      expect(page).to have_content(@paper.name)
    end

    within '.most-popular' do
      expect(page).to have_content(@index_cards.name)
      expect(page).to have_content(@gloves.name)
      expect(page).to have_content(@helmet.name)
    end
  end
end

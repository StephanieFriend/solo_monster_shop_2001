require 'rails_helper'

RSpec.describe 'As a merchant' do
  it 'can see same links as default user in addition to a merchant dashboard link' do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    merchant1 = User.create!({name: "Elmo", street_address: "123 Sesame St", city: "New York",
                             state: "NY", zip_code: "10001", email_address: "elmo@example.com",
                             password: "password1", password_confirmation: "password1",
                             role: 1, merchant_id: meg.id})

    visit '/'
    click_link 'Log in'

    fill_in :email_address, with: 'elmo@example.com'
    fill_in :password, with: 'password1'
    click_button 'Log in'

    expect(merchant1.role).to eq("merchant")
    expect(current_path).to eq('/merchant')
    expect(page).to have_content("Logged in as #{merchant1.name}")

    within 'nav' do
      expect(page).to have_no_link('Log in')
      expect(page).to have_no_link('Register')
    end

    within 'nav' do
      click_link 'All Items'
    end

    expect(current_path).to eq('/items')

    within 'nav' do
      click_link 'All Merchants'
    end

    expect(current_path).to eq('/merchants')

    within 'nav' do
      click_link "Home"
    end

    expect(current_path).to eq('/')

    within 'nav' do
      click_link "Cart"
    end

    expect(current_path).to eq('/cart')

    within 'nav' do
      click_link "Profile"
    end

    expect(current_path).to eq('/user/profile')

    within 'nav' do
      click_link "Merchant Dashboard"
    end

    expect(current_path).to eq('/merchant')

    within 'nav' do
      click_link "Log out"
    end

    expect(current_path).to eq('/')
  end

  it 'does not have access to admin' do
    user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "bob@example.com",
                         password: "password1", password_confirmation: "password1", role: 1
                        })

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    expect(user.role).to eq("merchant")

    visit "/admin"
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end

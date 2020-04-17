require 'rails_helper'

RSpec.describe "Logging out" do


it "can log out as a user" do
  user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                       state: "CO", zip_code: "80375", email_address: "bob@example.com",
                       password: "password1", password_confirmation: "password1", role: 0
                      })
  visit '/login'
  fill_in :email_address, with: "bob@example.com"
  fill_in :password, with: "password1"
  within ("#login-form") do
    click_on "Log in"
  end
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  click_on "Log out"
  expect(current_path).to eq('/')
  expect(page).to have_content("Bye #{user.name}! You are now logged out.")
  within("nav") do
    expect(page).to have_content("Cart: 0")
  end
end

it "can log out as a merchant" do
  meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
  merchant = User.create({name: "Fred", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "fred@example.com",
                         password: "password1", password_confirmation: "password1", role: 1, merchant_id: meg.id
                        })
    visit '/login'
    fill_in :email_address, with: "fred@example.com"
    fill_in :password, with: "password1"
    within ("#login-form") do
      click_on "Log in"
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    click_on "Log out"
    expect(current_path).to eq('/')
    expect(page).to have_content("Bye #{merchant.name}! You are now logged out.")
    within("nav") do
      expect(page).to have_content("Cart: 0")
    end
  end

  it "can log out as a admin" do
    admin = User.create({name: "Jill", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "jill@example.com",
                         password: "password1", password_confirmation: "password1", role: 2
                        })
    visit '/login'
    fill_in :email_address, with: "jill@example.com"
    fill_in :password, with: "password1"
    within ("#login-form") do
      click_on "Log in"
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      click_on "Log out"
      expect(current_path).to eq('/')
      expect(page).to have_content("Bye #{admin.name}! You are now logged out.")
    end

end

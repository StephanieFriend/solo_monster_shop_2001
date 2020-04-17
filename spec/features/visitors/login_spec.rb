require 'rails_helper'

RSpec.describe 'as a visitor', type: :feature do
  it "can login as a regular user" do
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
    expect(page).to have_content("Welcome #{user.name}! You are now logged in!")
    expect(current_path).to eq('/user/profile')
  end

  it "can login as a merchant user" do
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
    expect(page).to have_content("Welcome #{merchant.name}! You are now logged in!")
    expect(current_path).to eq('/merchant')
  end

  it "can login as an admin user" do
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
    expect(page).to have_content("Welcome #{admin.name}! You are now logged in!")
    expect(current_path).to eq('/admin')
  end

  it "user can not visit the login page if they are already logged in" do
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
    visit "/login"
    expect(page).to have_content("#{user.name}! You are already logged in!")
    expect(current_path).to eq('/user/profile')
  end

  it "merchant can not visit the login page if they are already logged in" do
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
    visit "/login"
    expect(page).to have_content("#{merchant.name}! You are already logged in!")
    expect(current_path).to eq('/merchant')
  end

  it "admin can not visit the login page if they are already logged in" do
    admin = User.create({name: "Jill", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "jill@example.com",
                         password: "password1", password_confirmation: "password1", role: 2
                        })
    visit '/login'
    fill_in :email_address, with: "jisll@example.com"
    fill_in :password, with: "password1"
    within ("#login-form") do
      click_on "Log in"
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    visit "/login"
    expect(page).to have_content("#{admin.name}! You are already logged in!")
    expect(current_path).to eq('/admin')
  end




end
#
# User Story 15, Users who are logged in already are redirected
#
# As a registered user, merchant, or admin
# When I visit the login path
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that tells me I am already logged in

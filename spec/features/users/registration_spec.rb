require 'rails_helper'

RSpec.describe 'as a visitor', type: :feature do
  it "can register as a new user" do
    visit('/')
    click_on('Register')
    expect(current_path).to eq('/register')
    fill_in :name, with: "Bob"
    fill_in :street_address, with: "531 Pearl"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip_code, with: "80210"
    fill_in :email_address, with: "bob@example.com"
    fill_in :password, with: "Password123"
    fill_in :password_confirmation, with: "Password123"
    click_on('Submit')
    expect(current_path).to eq('/user/profile')
    expect(page).to have_content("Welcome Bob! You are now registered and logged in!")
  end

  it "can not register if they don't fill out all fields" do
    visit('/')
    click_on('Register')
    expect(current_path).to eq('/register')
    fill_in :street_address, with: "531 Pearl"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip_code, with: "80210"
    fill_in :email_address, with: "bob@example.com"
    fill_in :password, with: "Password123"
    fill_in :password_confirmation, with: "Password123"
    click_on('Submit')
    expect(page).to have_content("Name can't be blank")
  end

  it "can not register if their passwords don't match" do
    visit('/')
    click_on('Register')
    expect(current_path).to eq('/register')
    fill_in :name, with: "Bob"
    fill_in :street_address, with: "531 Pearl"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip_code, with: "80210"
    fill_in :email_address, with: "bob@example.com"
    fill_in :password, with: "Password123"
    click_on('Submit')
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  it "can not register with an existing email" do
    user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                      state: "CO", zip_code: "80375", email_address: "bob@example.com",
                      password: "password1", password_confirmation: "password1"
                      })

    visit('/')
    click_on('Register')
    expect(current_path).to eq('/register')
    fill_in :name, with: "Bob"
    fill_in :street_address, with: "531 Pearl"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip_code, with: "80210"
    fill_in :email_address, with: "bob@example.com"
    fill_in :password, with: "Password123"
    fill_in :password_confirmation, with: "Password123"
    click_on('Submit')
    expect(page).to have_content("Email address already has an account associated with it")
    expect(current_path).to eq('/register')
  end
end

require 'rails_helper'

RSpec.describe "As a registered user" do
  it "can see all profile data except password on the profile page with link to edit profile data" do
    user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "bob@example.com",
                         password: "password1", password_confirmation: "password1", role: 0
                        })
    visit '/'

    click_link 'Log in'

    fill_in :email_address, with: 'bob@example.com'
    fill_in :password, with: 'password1'
    click_button 'Log in'

    expect(current_path).to eq('/user/profile')
    expect(page).to have_content("Logged in as #{user.name}")
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.street_address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)
    expect(page).to have_content(user.email_address)
    expect(page).to_not have_content(user.password)
    expect(page).to have_link("Edit Profile Info")
    expect(page).to have_link("Edit Password")
  end
end

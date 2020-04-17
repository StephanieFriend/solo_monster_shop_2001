require 'rails_helper'

RSpec.describe "As a registered user" do
  before(:each) do
    user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
      state: "CO", zip_code: "80375", email_address: "bob@example.com",
      password: "password1", password_confirmation: "password1", role: 0
      })

      visit '/'

      click_link 'Log in'

      fill_in :email_address, with: 'bob@example.com'
      fill_in :password, with: 'password1'
      click_button 'Log in'
  end

  it "can see all profile data expect password on the profile page with link to edit profile data" do
    click_link 'Edit Password'
    expect(current_path).to eq(edit_password_path)

    fill_in :password, with: 'bobbie2020'
    fill_in :password_confirmation, with: 'bobbie2020'
    click_button 'Submit'

    expect(page).to have_content("Your password is updated")
    expect(current_path).to eq(user_profile_path)
  end

  it "cannot update a password that doesn't match" do
    click_link 'Edit Password'
    expect(current_path).to eq(edit_password_path)

    fill_in :password, with: 'bobbie2020'
    fill_in :password_confirmation, with: 'bobbie20'
    click_button 'Submit'

    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(current_path).to eq(edit_password_path)
  end
end

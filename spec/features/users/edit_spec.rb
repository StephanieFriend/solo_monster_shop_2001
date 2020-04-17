require 'rails_helper'

RSpec.describe "As a registered user" do
  it "can update user information except for password by clicking link Edit Profile Info" do
    user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "bob@example.com",
                         password: "password1", password_confirmation: "password1", role: 0
                        })
    visit '/'

    click_link 'Log in'

    fill_in :email_address, with: 'bob@example.com'
    fill_in :password, with: 'password1'
    click_button 'Log in'
    click_link("Edit Profile Info")

    expect(current_path).to eq('/user/profile/edit')
    fill_in :street_address, with: "531 Pearl"
    fill_in :city, with: "Denver"
    click_on('Submit')

    expect(current_path).to eq('/user/profile')
    expect(page).to have_content('Your information is updated')

    user.reload

    expect(current_path).to eq('/user/profile')
    expect(page).to have_content("Logged in as #{user.name}")
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.street_address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip_code)
    expect(page).to have_content(user.email_address)
  end

  it "cannot update email address that is already in use" do
    User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "bob@example.com",
                         password: "password1", password_confirmation: "password1", role: 0
                        })
    User.create({name: "John", street_address: "20 Lake st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "john@example.com",
                         password: "password1", password_confirmation: "password1", role: 0
                        })
    visit '/'

    click_link 'Log in'

    fill_in :email_address, with: 'bob@example.com'
    fill_in :password, with: 'password1'
    click_button 'Log in'
    click_link("Edit Profile Info")

    expect(current_path).to eq('/user/profile/edit')
    fill_in :email_address, with: "john@example.com"
    click_on('Submit')
    expect(page).to have_content("Email address already has an account associated with it")
    expect(current_path).to eq('/user/profile/edit')
  end
end

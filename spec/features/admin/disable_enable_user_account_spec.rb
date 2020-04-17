require 'rails_helper'

RSpec.describe 'As an admin' do
  it 'I can disable a users account' do
    @bob = User.create({name: "Bob",
                        street_address: "22 dog st",
                        city: "Fort Collins",
                        state: "CO",
                        zip_code: "80375",
                        email_address: "user@example.com",
                        password: "password_regular",
                        password_confirmation: "password_regular",
                        role: 0
                       })
    @bert = User.create({name: "Bert",
                         street_address: "123 Sesame St.",
                         city: "New York City",
                         state: "NY",
                         zip_code: "10001",
                         email_address: "admin@example.com",
                         password: "password_admin",
                         password_confirmation: "password_admin",
                         role: 2
                        })
    visit '/'

    click_on 'Log in'
    fill_in :email_address, with: 'admin@example.com'
    fill_in :password, with: 'password_admin'
    click_button 'Log in'

    visit "/admin/users"

    within "#user-#{@bob.id}" do
      expect(page).to have_button("disable")

      click_button 'disable'
      expect(page).to have_button("enable")
    end

    expect(current_path).to eq('/admin/users')
    expect(page).to have_content("#{@bob.name}'s account has now been disabled")
    @bob.reload
    click_on 'Log out'

    click_on 'Log in'
    fill_in :email_address, with: 'user@example.com'
    fill_in :password, with: 'password_regular'
    click_button 'Log in'

    expect(current_path).to eq('/')
    expect(page).to have_content("Your account has been disabled")

    within 'nav' do
      expect(page).to have_content('Log in')
      expect(page).to have_content('Register')
    end
  end
end

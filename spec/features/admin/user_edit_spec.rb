require 'rails_helper'

RSpec.describe 'As an admin' do
  it 'I can edit a users profile' do
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

    visit "/admin/users/#{@bob.id}"

    click_link 'Edit Profile Info'

    fill_in :name, with: "Elmo"
    click_button 'Submit'

    expect(current_path).to eq("/admin/users/#{@bert.id}")
    expect(page).to have_content("Elmo")
    expect(page).to have_no_content("Bert")
  end
end




# As an admin user
# When I visit a user's profile page ("/admin/users/5")
# And I click the link to edit the user's profile data
# The same behaviors exist as if I were that user trying to change their own data
# Except I am returned to the show page path of
# "/admin/users/5" when I am finished
require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do
  it 'I can add a new bulk discount' do
    @meg = Merchant.create(name: "Meg's Bike Shop",
                           address: '123 Bike Rd.',
                           city: 'Denver',
                           state: 'CO',
                           zip: 80203)

    @regina = User.create({name: "Regina",
                           street_address: "6667 Evil Ln",
                           city: "Storybrooke",
                           state: "ME",
                           zip_code: "00435",
                           email_address: "evilqueen@example.com",
                           password: "henry2004",
                           password_confirmation: "henry2004",
                           role: 1,
                           merchant_id: @meg.id
                          })

    visit '/'
    click_link 'Log in'
    fill_in :email_address, with: @regina.email_address
    fill_in :password, with: @regina.password
    click_button 'Log in'

    click_link 'Update Bulk Discount Rates'

    expect(current_path).to eq("/merchant/#{@regina.merchant_id}/bulk_discounts")

    click_link 'Add A Bulk Rate'

    expect(current_path).to eq("/merchant/#{@regina.merchant_id}/bulk_discounts/new")

    fill_in :percentage, with: 15
    fill_in :quantity, with: 40
    click_button 'Submit Discount Rate'

    expect(page).to have_content("Percentage Off: 15")
    expect(page).to have_content("Item Quantity: 40")

    expect(current_path).to eq("/merchant/#{@regina.merchant_id}/bulk_discounts")
  end
end


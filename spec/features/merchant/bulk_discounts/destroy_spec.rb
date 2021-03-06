require 'rails_helper'

RSpec.describe 'As a Merchant Employee' do
  it 'I can see a list of all my merchants bulk discounts' do
    @meg = Merchant.create(name: "Meg's Bike Shop",
                           address: '123 Bike Rd.',
                           city: 'Denver',
                           state: 'CO',
                           zip: 80203)

    @discount1 = @meg.bulk_discounts.create(percentage: 10,
                                            quantity: 20)
    @discount2 = @meg.bulk_discounts.create(percentage: 5,
                                            quantity: 7)

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

    within "#discount-#{@discount1.id}" do
      click_link 'Delete Bulk Discount'
    end

    expect(current_path).to eq("/merchant/#{@regina.merchant_id}/bulk_discounts")

    expect(BulkDiscount.exists?(@discount1.id)).to be_falsey

    within "#discount-#{@discount2.id}" do
      expect(page).to have_content("Percentage Off: #{@discount2.percentage}")
      expect(page).to have_content("Item Quantity: #{@discount2.quantity}")
    end
  end
end

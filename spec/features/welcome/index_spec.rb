require 'rails_helper'

RSpec.describe 'as a visitor', type: :feature do
  it "can see a home page" do
    visit('/')
    expect(page).to have_content("Welcome to Monster Shop")
  end
end

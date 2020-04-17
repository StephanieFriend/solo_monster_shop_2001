require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it { should validate_uniqueness_of(:email_address).case_insensitive
                                                      .with_message("already has an account associated with it")}
    it { should validate_presence_of :name }
    it { should validate_presence_of :street_address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip_code }
    it { should validate_presence_of :email_address }
    it { should validate_presence_of :password }
  end

  describe "relationships" do
    it { should have_many :orders }
  end

  describe 'instance methods' do
    before :each do
      @user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                           state: "CO", zip_code: "80375", email_address: "bob@example.com",
                           password: "password1", password_confirmation: "password1", role: 0
                          })
      Order.create({name: "Bob", address: "22 dog st", city: "Fort Collins",
                   state: "CO", zip: "80375", user_id: @user.id})

    end

    it 'has_orders' do
      expect(@user.has_orders?).to eq(true)
    end
  end


end

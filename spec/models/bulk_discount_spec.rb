require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :quantity }
  end

  describe 'Relationships' do
    it {should belong_to :merchant}
  end

end
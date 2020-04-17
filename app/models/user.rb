class User < ApplicationRecord
  validates :email_address, uniqueness: { case_sensitive: false,
    message: "already has an account associated with it"}

  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zip_code,
                        :email_address

  has_many :orders
  belongs_to :merchant, optional: true

  enum role: {user: 0, merchant: 1, admin: 2}

  has_secure_password



  def has_orders?
    orders != []
  end

end

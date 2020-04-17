class Merchant::DashboardController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def show
    @order = Order.find(params[:id])
    @merchant_items = @order.items.where("merchant_id =?", current_user.merchant_id)
  end
end

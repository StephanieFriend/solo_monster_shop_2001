class Admin::OrdersController < Admin::BaseController

  def show
    @order = Order.find(params[:order_id])
  end 

end

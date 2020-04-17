class Admin::DashboardController < Admin::BaseController
  def index
    orders = []
    orders << Order.order(:status).where("status != 'Cancelled'")
    orders << Order.where("status = 'Cancelled'")
    @orders = orders.flatten
  end
end

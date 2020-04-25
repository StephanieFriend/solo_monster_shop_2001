class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end

  def new
    @merchant = Merchant.find(current_user[:merchant_id])
    @item = Item.new
  end

  def create
    @merchant = Merchant.find(current_user[:merchant_id])
    @item = @merchant.items.create(item_params)
    @item.image = "https://www.intemposoftware.com/uploads/blog/Blog_inventory_control.jpg" if item_params[:image] == ""
    if @item.save
      flash[:notice] = "Your item '#{@item.name}' has been saved"
      redirect_to "/merchant/#{@merchant.id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render(:new)
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def status
    @item = Item.find(params[:item_id])
    if params[:activate_or_deactivate] == "deactivate"
      @item.update(active?: false)
      flash[:notice] = "#{@item.name} is no longer for sale"
    elsif params[:activate_or_deactivate] == "activate"
      @item.update(active?: true)
      flash[:notice] = "#{@item.name} is now available for sale"
    end
    redirect_to "/merchant/#{@item.merchant.id}/items"
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params) && @item.save
      @item.image = "https://www.intemposoftware.com/uploads/blog/Blog_inventory_control.jpg" if item_params[:image] == ""
      @item.save
      flash[:success] = "Your item '#{@item.name}' has been updated"
      redirect_to "/merchant/#{@item.merchant.id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def fulfill
    item = Item.find(params[:item_id])
    item_order = item.item_orders.where("item_orders.order_id =?", params[:order_id]).first
    item_order.update(fulfilled?: true)
    item.inventory -= item_order.quantity
    item.save
    flash[:success] = "You have fulfilled #{item.name}"
    order = Order.find(params[:order_id])
    if order.item_orders.where(fulfilled?: false) == []
      order.status = "Packaged"
      order.save
    end
    redirect_to "/merchant/orders/#{params[:order_id]}"
  end

  def destroy
    item = Item.find(params[:id])
    flash[:notice] = "#{item.name} has been deleted"
    item.destroy
    redirect_to "/merchant/#{item.merchant.id}/items"
  end

  private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end
end

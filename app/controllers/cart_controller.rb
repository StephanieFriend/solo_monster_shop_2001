class CartController < ApplicationController
  before_action :require_not_admin

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment
    item = Item.find(params[:item_id])
    cart.contents.each do |item_id, quantity|
      if item.id.to_s == item_id
        if quantity < item.inventory
          cart.contents[item_id] += 1
        else
          flash[:inventory_notice] = "There's not enough of this item in stock, please choose another."
        end
      end
    end
    redirect_to '/cart'
  end

  def decrement
    item = Item.find(params[:item_id])
    cart.contents.each do |item_id, quantity|
      if item.id.to_s == item_id
        if quantity == 1
          remove_item
        else
          cart.contents[item_id] -= 1
          redirect_to '/cart'
        end
      end
    end
  end

private
  def require_not_admin
    render file: "/public/404" if current_admin?
  end
end

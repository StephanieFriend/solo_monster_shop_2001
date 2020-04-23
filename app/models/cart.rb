class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def discount_item(item)
    BulkDiscount.joins(:merchant).where("bulk_discounts.merchant_id =?", item.merchant_id).where("bulk_discounts.quantity <=?", items[item]).order(quantity: :DESC).order(percentage: :DESC).first
  end

  def calc_percent(discount, item)
    discounted_price = (discount.percentage.to_f / 100) * (item.price * @contents[item.id.to_s])
    new_subtotal = (item.price * @contents[item.id.to_s]) - discounted_price
    return new_subtotal
  end

  def subtotal(item)
    if !discount_item(item).nil? && @contents.keys.include?(item.id.to_s) && discount_item(item).merchant_id == item.merchant_id
      calc_percent(discount_item(item), item)
    else
      (item.price * @contents[item.id.to_s])
    end
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end
end

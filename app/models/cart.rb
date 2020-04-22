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

  def discount_item
    discounts = []
    items.each do |item, quantity|
      BulkDiscount.all.each do |discount|
        if discount.merchant_id == item.merchant_id
          discounts << discount
        end
      end
    end
    discounts
  end

  def subtotal(item)
    @contents.each do |item_id, quantity|
      discount_item.each do |discount|
        if item_id == item.id.to_s && discount.merchant_id == item.merchant_id
          if discount.quantity <= quantity
            d = discount_item.select {|dis| dis.quantity <= quantity}.max_by {|dis| dis.quantity}
            new_discounted_price = (d.percentage.to_f / 100) * (item.price * @contents[item.id.to_s])
            new_subtotal = (item.price * @contents[item.id.to_s]) - new_discounted_price
            return new_subtotal
          end
        end
      end
    end
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end
end

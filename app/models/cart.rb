class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      # grand_total += Item.find(item_id).price * quantity
      grand_total += discounted_subtotal(item_id, quantity)
    end
    grand_total
  end

  def discounted_subtotal(item_id, quantity)
    item = Item.find(item_id)
    discount = item.merchant.bulk_discounts.order(percentage: :desc).where("item_quantity <= #{quantity}").first
    if discount.nil?
      item.price * quantity
    else
      percentage = (100 - discount.percentage)/100
      adjusted_price = item.price * percentage
      adjusted_price * quantity
    end
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end

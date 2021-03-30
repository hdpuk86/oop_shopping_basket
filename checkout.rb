require 'Ostruct'

class Checkout
  attr_accessor :raw_total
  attr_reader :items, :promotions

  def initialize
    @promotions = []
    @items = []
    @raw_total = 0
  end

  def total
    total_after_discounts
  end

  def scan_item(item)
    self.items.push(item)
    self.raw_total += item.price
  end

  def add_promo(promo)
    self.promotions.push(promo)
  end

  private

  def total_after_discounts
    self.promotions.reduce(self.raw_total) do |current_total, promo|
      basket = OpenStruct.new({ items: self.items, total: current_total })
      current_total - promo.calculate_discount(basket)
    end
  end
end

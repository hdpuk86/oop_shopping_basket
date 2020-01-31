class Checkout
  attr_accessor :rules, :basket

  def initialize(rules=[])
    @rules = rules
    @basket = Basket.new
  end

  def total
    self.basket.total - discounts
  end

  def scan(item)
    self.basket.total += item.price
  end

  def discounts
    all_promo_discounts = self.rules.map { |rule| rule.calculate_discount(self.basket) }
    all_promo_discounts.compact.sum
  end
end

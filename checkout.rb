class Checkout
  attr_accessor :raw_total
  attr_reader :items, :rules

  def initialize(rules = Rules.new)
    @rules = rules
    @items = []
    @raw_total = 0
  end

  def total
    self.raw_total - discounts
  end

  def scan(item)
    self.items.push(item)
    self.raw_total += item.price
  end

  def discounts
    multibuy_discounts = calculate_discounts(self.rules.multibuy, self.items, self.raw_total)
    new_total = self.raw_total - multibuy_discounts

    basket_discounts = calculate_discounts(self.rules.basket, self.items, new_total)
    multibuy_discounts + basket_discounts
  end

  private

  def calculate_discounts(promos, items, current_total)
    promos.map { |rule| rule.calculate_discount(items, current_total) }.compact.sum
  end
end

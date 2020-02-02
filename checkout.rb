class Checkout
  attr_accessor :raw_total
  attr_reader :items, :rules

  def initialize(rules = Rules.new)
    @rules = rules
    @items = []
    @raw_total = 0
  end

  def total
    self.raw_total - PromoCalculator.discounts(self.rules, self.items, self.raw_total)
  end

  def scan(item)
    self.items.push(item)
    self.raw_total += item.price
  end
end

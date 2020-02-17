require 'byebug'
class Checkout
  attr_accessor :raw_total
  attr_reader :items, :rules

  def initialize(rules = Rules.new)
    @rules = rules
    @items = []
    @raw_total = 0
  end

  def total
    total_after_discounts
  end

  def scan(item)
    self.items.push(item)
    self.raw_total += item.price
  end

  def add_rule(rule)
    self.rules.add(rule)
  end

  private

  def total_after_discounts
    self.rules.promotions.reduce(self.raw_total) do |current_total, rule|
      current_total - rule.calculate_discount(self.items, current_total)
    end
  end
end

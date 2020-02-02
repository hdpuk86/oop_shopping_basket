class PromoCalculator
  def self.discounts(rules, items, current_total)
    multibuy_discounts = calculate_discounts(rules.of_type('multibuy'), items, current_total)
    new_total = current_total - multibuy_discounts

    basket_discounts = calculate_discounts(rules.of_type('basket'), items, new_total)
    multibuy_discounts + basket_discounts
  end

  private

  def self.calculate_discounts(rules, items, current_total)
    rules.map { |rule| rule.calculate_discount(items, current_total) }.compact.sum
  end
end

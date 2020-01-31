require 'minitest/autorun'

class ShoppingBasketTests < MiniTest::Test
  def setup
    basket_promo = Promo.new(100, 20)
    @rules = [basket_promo]
    @co = Checkout.new(@rules)
    @item_a = Item.new(2)
  end

  def test_can_create_checkout
    assert Checkout.new
  end

  def test_checkout_can_have_rules
    assert_equal @rules, @co.rules
  end

  def test_checkout_has_a_total
    assert @co.total
  end

  def test_checkout_total_starts_at_zero
    assert_equal 0, @co.total
  end

  def test_checkout_can_scan_items
    assert @co.scan(@item_a)
  end

  def test_checkout_total_increases_when_item_scanned
    @co.scan(@item_a)
    assert_equal 2, @co.total
  end

  def test_checkout_total_increases_by_item_price_when_scanned
    @co.scan(@item_a)
    assert_equal @item_a.price, @co.total
  end

  def test_basket_discount_can_get_applied
    item = Item.new(100)
    @co.scan(item)
    assert_equal 80, @co.total
  end

  def test_basket_discount_does_not_get_applied_if_target_not_met
    item = Item.new(99)
    @co.scan(item)
    assert_equal 99, @co.total
  end
end

class Promo
  attr_accessor :target_amount, :discount

  def initialize(target_amount, discount)
    @target_amount = target_amount
    @discount = discount
  end

  def calculate_discount(basket)
    return self.discount if basket.total >= self.target_amount
  end
end

class Item
  attr_accessor :price

  def initialize(price)
    @price = price
  end
end

class Basket
  attr_accessor :total

  def initialize
    @total = 0
  end
end

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

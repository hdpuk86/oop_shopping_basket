require 'minitest/autorun'

require_relative 'basket'
require_relative 'checkout'
require_relative 'item'
require_relative 'promo'

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

  def test_basket_discount_can_be_applied_if_target_is_met
    item = Item.new(100)
    @co.scan(item)
    assert_equal 80, @co.total
  end

  def test_basket_discount_can_be_applied_if_target_is_exceeded
    item = Item.new(200)
    @co.scan(item)
    assert_equal 180, @co.total
  end

  def test_basket_discount_does_not_get_applied_if_target_not_met
    item = Item.new(99)
    @co.scan(item)
    assert_equal 99, @co.total
  end
end

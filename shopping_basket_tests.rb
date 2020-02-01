require 'minitest/autorun'

require_relative 'basket'
require_relative 'checkout'
require_relative 'item'
require_relative 'rule_types/basket_promo'
require_relative 'rule_types/multibuy_promo'

class ShoppingBasketTests < MiniTest::Test
  def setup
    @item_a = Item.new(30)
    @item_b = Item.new(20)
    @item_c = Item.new(50)
    @item_d = Item.new(15)

    @multibuy_a = MultibuyPromo.new(@item_a, 3, 75)
    @multibuy_b = MultibuyPromo.new(@item_b, 2, 35)
    @basket_promo = BasketPromo.new(150, 20)
    @rules = [@multibuy_a, @multibuy_b, @basket_promo]

    @co = Checkout.new(@rules)
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

    assert_equal 30, @co.total
  end

  def test_checkout_total_increases_by_item_price_when_scanned
    @co.scan(@item_a)

    assert_equal @item_a.price, @co.total
  end

  def test_basket_discount_can_be_applied_if_target_is_met
    item = Item.new(100)
    co = Checkout.new([BasketPromo.new(100, 20)])

    co.scan(item)

    assert_equal 80, co.total
  end

  def test_basket_discount_can_be_applied_if_target_is_exceeded
    item = Item.new(200)
    co = Checkout.new([BasketPromo.new(100, 20)])

    co.scan(item)

    assert_equal 180, co.total
  end

  def test_basket_discount_does_not_get_applied_if_target_not_met
    item = Item.new(99)
    co = Checkout.new([BasketPromo.new(100, 20)])

    co.scan(item)

    assert_equal 99, co.total
  end

  def test_multibuy_promo_can_be_applied_if_target_is_met
    item_a = Item.new(10)
    multibuy = MultibuyPromo.new(item_a, 3, 8)
    co = Checkout.new([multibuy])

    3.times do
      co.scan(item_a)
    end

    assert_equal multibuy.promo_price, co.total
  end

  def test_multibuy_promo_can_be_applied_correctly_if_target_is_exceeded
    item_a = Item.new(10)
    co = Checkout.new([MultibuyPromo.new(item_a, 3, 8)])

    4.times do
      co.scan(item_a)
    end

    assert_equal 18, co.total
  end

  def test_checkout_can_apply_multiple_rules__multibuy_and_basket
    item_a = Item.new(10)
    rules = [
      MultibuyPromo.new(item_a, 2, 18),
      BasketPromo.new(30, 5)
    ]
    co = Checkout.new(rules)

    4.times do
      co.scan(item_a)
    end

    assert_equal 31, co.total
  end
end

require 'minitest/autorun'

require_relative 'checkout'
require_relative 'item'
require_relative 'promo_types/basket_promo'
require_relative 'promo_types/multibuy_promo'
require_relative 'rules'

class ShoppingBasketTests < MiniTest::Test
  def setup
    @item_a = Item.new(30)
    @item_b = Item.new(20)
    @item_c = Item.new(50)
    @item_d = Item.new(15)

    @multibuy_a = MultibuyPromo.new(@item_a, 3, 75) #save 15
    @multibuy_b = MultibuyPromo.new(@item_b, 2, 35) #save 5
    @basket_promo = BasketPromo.new(150, 20)

    @co = Checkout.new

    @co.add_rule(@multibuy_a)
    @co.add_rule(@multibuy_b)
    @co.add_rule(@basket_promo)
  end

  def test_can_create_checkout
    assert Checkout.new
  end

  def test_checkout_can_have_rules
    rules = Rules.new
    co = Checkout.new(rules)
    assert_equal rules, co.rules
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

  def test_checkout_total_is_accurate_without_rules
    co = Checkout.new
    co.scan(@item_a)

    assert_equal @item_a.price, co.total
  end

  def test_basket_discount_can_be_applied_if_target_is_met
    item = Item.new(100)
    rules = Rules.new
    rules.add(BasketPromo.new(100, 20))
    co = Checkout.new(rules)

    co.scan(item)

    assert_equal 80, co.total
  end

  def test_basket_discount_can_be_applied_if_target_is_exceeded
    item = Item.new(200)
    rules = Rules.new
    rules.add(BasketPromo.new(100, 20))
    co = Checkout.new(rules)

    co.scan(item)

    assert_equal 180, co.total
  end

  def test_basket_discount_does_not_get_applied_if_target_not_met
    item = Item.new(99)
    rules = Rules.new
    rules.add(BasketPromo.new(100, 20))
    co = Checkout.new(rules)

    co.scan(item)

    assert_equal 99, co.total
  end

  def test_multibuy_promo_can_be_applied_if_target_is_met
    item_a = Item.new(10)
    rules = Rules.new
    multibuy = MultibuyPromo.new(item_a, 3, 8)
    rules.add(multibuy)
    co = Checkout.new(rules)

    3.times { co.scan(item_a) }

    assert_equal multibuy.promo_price, co.total
  end

  def test_multibuy_promo_can_be_applied_correctly_if_target_is_exceeded
    item_a = Item.new(10)
    rules = Rules.new
    rules.add(MultibuyPromo.new(item_a, 3, 8))
    co = Checkout.new(rules)

    4.times { co.scan(item_a) }

    assert_equal 18, co.total
  end

  def test_checkout_can_apply_multiple_rules__multibuy_and_basket
    item_a = Item.new(10)
    rules = Rules.new
    rules.add(MultibuyPromo.new(item_a, 2, 18))
    rules.add(BasketPromo.new(30, 5))
    co = Checkout.new(rules)

    4.times { co.scan(item_a) }

    assert_equal 31, co.total
  end

  def test_checkout_can_handle_multiple_items
    3.times { @co.scan(@item_b) }
    @co.scan(@item_c)

    assert_equal 105, @co.total
  end

  def test_basket_promo_applied_after_other_promos
    item_a = Item.new(10)
    rules = Rules.new
    rules.add(MultibuyPromo.new(item_a, 2, 18))
    rules.add(BasketPromo.new(20, 5))
    co = Checkout.new(rules)

    2.times do
      co.scan(item_a)
    end

    assert_equal 18, co.total
  end

  # # Test Example Data

  # # A, B, C £100
  def test_no_promos
    @co.scan(@item_a)
    @co.scan(@item_b)
    @co.scan(@item_c)

    assert_equal 100, @co.total
  end

  # # B, A, B, A, A £110
  def test_two_multibuy_promos
    @co.scan(@item_b)
    @co.scan(@item_a)
    @co.scan(@item_b)
    @co.scan(@item_a)
    @co.scan(@item_a)

    assert_equal 110, @co.total
  end

  # # C, B, A, A, D, A, B £155
  def test_two_multibuy_promos_and_basket_promo
    @co.scan(@item_a)
    @co.scan(@item_a)
    @co.scan(@item_a)
    @co.scan(@item_b)
    @co.scan(@item_b)
    @co.scan(@item_c)
    @co.scan(@item_d)

    assert_equal 155, @co.total
  end

  # # C, A, D, A, A £140
  def test_basket_promo_not_applied_when_a_discount_reduces_total_below_target
    @co.scan(@item_c)
    @co.scan(@item_a)
    @co.scan(@item_d)
    @co.scan(@item_a)
    @co.scan(@item_a)

    assert_equal 140, @co.total
  end
end

require 'minitest/autorun'

require_relative 'checkout'
require_relative 'item'
require_relative 'promo_types/basket_promo'
require_relative 'promo_types/multibuy_promo'

class ShoppingBasketTests < MiniTest::Test
  def setup
    @item_a = Item.new(price: 30)
    @item_b = Item.new(price: 20)
    @item_c = Item.new(price: 50)
    @item_d = Item.new(price: 15)

    @multibuy_a = MultibuyPromo.new(promo_item: @item_a, number_of_items_needed: 3, promo_price: 75) #save 15
    @multibuy_b = MultibuyPromo.new(promo_item: @item_b, number_of_items_needed: 2, promo_price: 35) #save 5
    @basket_promo = BasketPromo.new(target_amount: 150, discount: 20)

    @co = Checkout.new

    @co.add_promo(@multibuy_a)
    @co.add_promo(@multibuy_b)
    @co.add_promo(@basket_promo)
  end

  def test_can_create_checkout
    assert Checkout.new
  end

  def test_checkout_can_have_promotions
    co = Checkout.new
    assert_equal [], co.promotions
  end

  def test_checkout_has_a_total
    assert @co.total
  end

  def test_checkout_total_starts_at_zero
    assert_equal 0, @co.total
  end

  def test_checkout_can_scan_item_items
    assert @co.scan_item(@item_a)
  end

  def test_checkout_total_increases_when_item_scan_itemned
    @co.scan_item(@item_a)

    assert_equal 30, @co.total
  end

  def test_checkout_total_increases_by_item_price_when_scan_itemned
    @co.scan_item(@item_a)

    assert_equal @item_a.price, @co.total
  end

  def test_checkout_total_is_accurate_without_promotions
    co = Checkout.new
    co.scan_item(@item_a)

    assert_equal @item_a.price, co.total
  end

  def test_basket_discount_can_be_applied_if_target_is_met
    item = Item.new(price: 100)
    co = Checkout.new
    co.add_promo(BasketPromo.new(target_amount: 100, discount: 20))

    co.scan_item(item)

    assert_equal 80, co.total
  end

  def test_basket_discount_can_be_applied_if_target_is_exceeded
    item = Item.new(price: 200)
    co = Checkout.new
    co.add_promo(BasketPromo.new(target_amount: 100, discount: 20))

    co.scan_item(item)

    assert_equal 180, co.total
  end

  def test_basket_discount_does_not_get_applied_if_target_not_met
    item = Item.new(price: 99)
    co = Checkout.new
    co.add_promo(BasketPromo.new(target_amount: 100, discount: 20))

    co.scan_item(item)

    assert_equal 99, co.total
  end

  def test_multibuy_promo_can_be_applied_if_target_is_met
    item_a = Item.new(price: 10)
    multibuy = MultibuyPromo.new(promo_item: item_a, number_of_items_needed: 3, promo_price: 8)
    co = Checkout.new
    co.add_promo(multibuy)

    3.times { co.scan_item(item_a) }

    assert_equal multibuy.promo_price, co.total
  end

  def test_multibuy_promo_can_be_applied_correctly_if_target_is_exceeded
    item_a = Item.new(price: 10)
    co = Checkout.new
    co.add_promo(MultibuyPromo.new(promo_item: item_a, number_of_items_needed: 3, promo_price: 8))

    4.times { co.scan_item(item_a) }

    assert_equal 18, co.total
  end

  def test_checkout_can_apply_multiple_promotions__multibuy_and_basket
    item_a = Item.new(price: 10)
    co = Checkout.new
    co.add_promo(MultibuyPromo.new(promo_item: item_a, number_of_items_needed: 2, promo_price: 18))
    co.add_promo(BasketPromo.new(target_amount: 30, discount: 5))

    4.times { co.scan_item(item_a) }

    assert_equal 31, co.total
  end

  def test_checkout_can_handle_multiple_items
    3.times { @co.scan_item(@item_b) }
    @co.scan_item(@item_c)

    assert_equal 105, @co.total
  end

  def test_basket_promo_applied_after_other_promos
    item_a = Item.new(price: 10)
    co = Checkout.new
    co.add_promo(MultibuyPromo.new(promo_item: item_a, number_of_items_needed: 2, promo_price: 18))
    co.add_promo(BasketPromo.new(target_amount: 20, discount: 5))

    2.times do
      co.scan_item(item_a)
    end

    assert_equal 18, co.total
  end

  # # Test Example Data

  # # A, B, C £100
  def test_no_promos
    @co.scan_item(@item_a)
    @co.scan_item(@item_b)
    @co.scan_item(@item_c)

    assert_equal 100, @co.total
  end

  # # B, A, B, A, A £110
  def test_two_multibuy_promos
    @co.scan_item(@item_b)
    @co.scan_item(@item_a)
    @co.scan_item(@item_b)
    @co.scan_item(@item_a)
    @co.scan_item(@item_a)

    assert_equal 110, @co.total
  end

  # # C, B, A, A, D, A, B £155
  def test_two_multibuy_promos_and_basket_promo
    @co.scan_item(@item_a)
    @co.scan_item(@item_a)
    @co.scan_item(@item_a)
    @co.scan_item(@item_b)
    @co.scan_item(@item_b)
    @co.scan_item(@item_c)
    @co.scan_item(@item_d)

    assert_equal 155, @co.total
  end

  # # C, A, D, A, A £140
  def test_basket_promo_not_applied_when_a_discount_reduces_total_below_target
    @co.scan_item(@item_c)
    @co.scan_item(@item_a)
    @co.scan_item(@item_d)
    @co.scan_item(@item_a)
    @co.scan_item(@item_a)

    assert_equal 140, @co.total
  end
end

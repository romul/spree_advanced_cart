Feature: AdvancedCart

  @selenium
  Scenario: Add coupon in the cart
    Given a promotion with code "SPREE" and "FlatRate" amount "5"
    When I add a product with name: "RoR Mug", price: "40" to cart
    And I fill in "order_coupon_code" with "SPREE"
    And I press "Apply"
    Then I should see "Coupon (SPREE)"
    And I should see "-$5"
    And I should see "Total: $35"

  @selenium
  Scenario: Precalculate shipping cost in the cart 
    Given a shipping_method with name "UPS Ground" and "FlatRate" amount "5"
    When I add a product with name: "RoR Mug", price: "40" to cart
    And I fill in "zipcode" with "90210"
    And I press "Calc"
    Then I should see "UPS Ground"
    And I should see "$5"
    And I should see "Total: $40"

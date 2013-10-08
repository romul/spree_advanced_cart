module Spree
  class AdvancedCartConfiguration < Preferences::Configuration
    preference :enable_shipping_cost_calculation, :boolean, :default => true
    preference :skip_zipcode_validation, :boolean, :default => false
  end
end

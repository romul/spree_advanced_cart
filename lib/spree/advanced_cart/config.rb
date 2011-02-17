module Spree
  module AdvancedCart
    # Singleton class to access the advanced cart configuration object (AdvancedCartConfiguration.first by default) and it's preferences.
    #
    # Usage:
    #   Spree::AdvancedCart::Config[:foo]                  # Returns the foo preference
    #   Spree::AdvancedCart::Config[]                      # Returns a Hash with all the google base preferences
    #   Spree::AdvancedCart::Config.instance               # Returns the configuration object (AdvancedCartConfiguration.first)
    #   Spree::AdvancedCart::Config.set(preferences_hash)  # Set the advanced cart preferences as especified in +preference_hash+
    class Config
      include Singleton
      include PreferenceAccess

      class << self
        def instance
          return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
          AdvancedCartConfiguration.find_or_create_by_name("Advanced Cart configuration")
        end
      end
    end
  end
end


module Spree
  module AdvancedCart
    class Engine < Rails::Engine
      isolate_namespace Spree
      engine_name 'spree_advanced_cart'
      
      initializer "spree.advanced_cart.environment", :before => :load_config_initializers do |app|
        Spree::AdvancedCart::Config = Spree::AdvancedCartConfiguration.new
      end

      config.autoload_paths += %W(#{config.root}/lib)

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
        
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/overrides/*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end

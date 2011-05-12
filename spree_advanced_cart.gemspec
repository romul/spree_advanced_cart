Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_advanced_cart'
  s.version     = '0.40.0'
  s.summary     = 'Cart with several useful additions for Spree'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Roman Smirnov'
  s.email             = 'roman@railsdog.com'
  s.homepage          = 'http://github.com/romul/spree_advanced_cart'
  # s.rubyforge_project = 'actionmailer'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 0.40.0')
  s.add_dependency('spree_promo', '>= 0.40.0')
  s.add_dependency('zip-code-info', '>= 0.1.0')
end


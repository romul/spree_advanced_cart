Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_advanced_cart'
  s.version     = '1.0.0'
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

  s.add_dependency 'spree_core', '~> 1.0'
  s.add_dependency('spree_promo', '~> 1.0')
  s.add_dependency('zip-code-info', '>= 0.1.0')
  
  s.add_development_dependency('rspec-rails',  '~> 2.7')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('capybara')
  s.add_development_dependency('factory_girl', '~> 2.6')
end

Gem::Specification.new do |s|
  s.name = "lipstick"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Piers Chambers"]
  s.date = "2017-04-07"
  s.description = "Unofficial ruby wrapper for the Lime Light CRM membership and transaction APIs"
  s.email = "piers@varyonic.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/lipstick.rb",
    "lib/lipstick/api/campaign_find_active_response.rb",
    "lib/lipstick/api/campaign_view_response.rb",
    "lib/lipstick/api/customer_find_active_product_response.rb",
    "lib/lipstick/api/new_order_response.rb",
    "lib/lipstick/api/order_find_response.rb",
    "lib/lipstick/api/order_find_updated_response.rb",
    "lib/lipstick/api/order_view_response.rb",
    "lib/lipstick/api/response.rb",
    "lib/lipstick/api/session.rb",
    "lipstick.gemspec",
    "test/helper.rb",
    "test/test_lipstick.rb",
    "test/test_order_view_response.rb"
  ]
  s.homepage = "http://github.com/varyonic/lipstick"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Unofficial ruby wrapper for the Lime Light CRM APIs."

  s.add_development_dependency(%q<minitest>, ["~> 0"])
  s.add_development_dependency(%q<yard>, ["~> 0.9.11"])
  s.add_development_dependency(%q<bundler>, ["~> 1.0"])
  s.add_development_dependency(%q<simplecov>, ["~> 0"])
end


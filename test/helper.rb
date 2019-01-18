require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end

SimpleCov.configure do
  clean_filters
  load_adapter 'test_frameworks'
end

ENV["COVERAGE"] && SimpleCov.start do
  add_filter "/.rvm/"
end
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/autorun'
require 'minitest/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'lipstick'

require 'yaml'

module Lipstick
  module Fixtures
    HOME_DIR = RUBY_PLATFORM =~ /mswin32/ ? ENV['HOMEPATH'] : ENV['HOME'] unless defined?(HOME_DIR)

    def address(prefix, options = {})
      {
        "#{prefix}Address1" => '1234 My Street',
        "#{prefix}Address2" => 'Apt 1',
        "#{prefix}City"     => 'Ottawa',
        "#{prefix}State"    => 'ON',
        "#{prefix}Zip"      => 'K1C2N6',
        "#{prefix}Country"  => 'CA',
      }.update(options)
    end
  end
end

def context(*args, &block)
  describe(*args, &block)
end

Minitest.autorun

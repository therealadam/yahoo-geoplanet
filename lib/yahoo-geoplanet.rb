%w{rubygems cgi hpricot activesupport}.each { |x| require x }

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rest'
require 'yahoo-geoplanet/base'
require 'yahoo-geoplanet/version'

require 'yahoo-geoplanet/place'

module Yahoo
  module GeoPlanet
    LOCALE      = "us"
    API_VERSION = "v1"
    API_URL     = "http://where.yahooapis.com/v1/"
    
    class << self
      def app_id=(_id)
        Yahoo::GeoPlanet::Base::connection = REST::Connection.new(API_URL, 'app_id' => _id)
      end
    end
  end
end
require 'cgi'
require 'hpricot'

begin
  # ActiveSupport < 3
  require 'activesupport'
rescue LoadError => e
  # ActiveSupport > 3
  require 'active_support/core_ext/class/attribute_accessors'
  require 'active_support/core_ext/module/aliasing'
  require 'active_support/inflector'
end

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

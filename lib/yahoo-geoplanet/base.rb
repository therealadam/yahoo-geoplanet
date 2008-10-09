module Yahoo
  module GeoPlanet
    class Base
      class << self
        cattr_accessor  :connection
        
        def name_with_demodulization
          self.name_without_demodulization.demodulize        
        end
        
        alias_method_chain :name, :demodulization

        def fetch_and_parse(resource, options = {})      
          raise YahooWebServiceError, "No App ID specified" if connection.nil?    
          return Hpricot::XML(connection.get(resource, options))
        end
        
        def api_path(resource, id, collection, *args)
          parameters = [resource, id, collection, *args].compact
          return parameters.collect!{|param| CGI::escape(param.to_s).downcase}.join('/')
        end
      end
            
      def initialize(xml)
        raise ArgumentError unless xml.kind_of?(Hpricot)
      end
      
      def initialize_with_polymorphism(arg)
        case arg
        when Integer
          initialize_without_polymorphism(query_by_id(arg))
        when Hpricot
          initialize_without_polymorphism(arg)
        end
      end
     
      alias_method_chain :initialize, :polymorphism
      
    protected
      def query_by_id(id)
        xml = self.class.fetch_and_parse(self.class.api_path(self.class.name, id, nil))
        return xml.at(self.class.name.downcase)
      end
    end
  
    class YahooWebServiceError < StandardError; end
  end
end
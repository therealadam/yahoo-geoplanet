module Yahoo
  module GeoPlanet
    class Base
      class << self
        attr_accessor   :attributes
        cattr_accessor  :connection
        
        def attribute(*args)
          @attributes ||= {}
          
          options = args.extract_options!
          name, type = args
          class_eval %(attr_accessor :#{name})
          @attributes[name] = options.update({:type => type})

          if options[:type] == Boolean
            define_method("#{name}?".to_sym) do
              value = instance_variable_get("@#{name}")
              return value
            end
          end
        end
        
        def attributes
          @attributes || {}
        end
        
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
                
        self.class.attributes.each do |attribute, options|
          value = xml.at(options[:matcher] || attribute.to_s).inner_text
          begin
            if options[:type] == Integer
              value = value.to_i
            elsif options[:type] == Float
              value = value.to_f
            elsif options[:type] == Date
              value = Date.parse(value) rescue nil
            elsif options[:type] == Boolean
              value = !! value.to_i.nonzero?
            end
          ensure
            self.instance_variable_set("@#{attribute}", value)
          end     
        end        
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

class Boolean; end
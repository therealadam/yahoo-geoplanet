module Yahoo
  module GeoPlanet
    class Place < Base
      attribute :woeid,     Integer
      attribute :type,      String, :matcher => "placeTypeName"
      attribute :name,      String
      
      attr_reader  :latitude, :longitude, :bounding_box
      alias_method :lat, :latitude 
      alias_method :lon, :longitude
            
      def initialize_without_polymorphism(xml)
        super
        
        ["admin1", "admin2", "admin3", "locality1", "locality2", "postal"].each do |optional|
          begin
            element = xml.at(optional)          
            type  = element.attributes["type"].downcase.gsub(/\s+/, '_')
            value = element.inner_text
          
            self.class.class_eval %(attr_accessor :#{type})
            self.instance_variable_set("@#{type}", value)
          rescue
            next
          end
        end
        
        element = xml.at("centroid")
        @latitude = element.at("latitude").inner_text.to_f
        @longitude = element.at("longitude").inner_text.to_f
        
        element = xml.at("boundingBox")
        @bounding_box = ["northEast","southWest"].collect do |corner|
          corner = element.at(corner)
          [corner.at("latitude"), corner.at("longitude")].collect{|e| pp e; e.inner_text.to_f}
        end
      end
      
      class << self
        def search(query, options = {'count' => '20'})
          query = URI.encode(query.gsub(/\s+/, '+'))
          if options[:type]
            type = options.delete(:type).gsub(/\s+/, '+')
            term = "$and(.q('#{query}'),.type('#{type}'));"
          else
            term = ".q('#{query}');"
          end
          term << options.collect{|k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)]}.join(";")
          xml = fetch_and_parse('places' + term)
          return xml.search(self.name.downcase).collect{|elem| self.new(elem)}
        end
      end
    end
  end
end
module Yahoo
  module GeoPlanet
    class Place < Base
      attr_reader  :woe_id, :type, :name
      attr_reader  :latitude, :longitude, :bounding_box
      alias_method :lat, :latitude 
      alias_method :lon, :longitude
            
      def initialize_without_polymorphism(xml)
        super
        
        @woe_id = xml.at("woeid").inner_text
        @type   = xml.at("placeTypeName").inner_text
        @name   = xml.at("name").inner_text
        
        ["admin1", "admin2", "admin3", "locality1", "locality2", "postal"].each do |optional|
          begin
            element = xml.at(optional)
            next if element.empty?
            
            type  = element.attributes["type"].downcase.gsub(/\s+/, '_')
            value = element.inner_text
          
            self.class.class_eval %(attr_accessor :#{type})
            self.instance_variable_set("@#{type}", value)
          rescue
            next
          end
        end
        
        element = xml.at("centroid")
        @latitude  = element.at("latitude").inner_text.to_f
        @longitude = element.at("longitude").inner_text.to_f
      
        element = xml.at("boundingBox")
        @bounding_box = ["northEast","southWest"].collect do |corner|
          corner = element.at(corner)
          [corner.at("latitude"), corner.at("longitude")].collect{|e| e.inner_text.to_f}
        end
      end
      
      # Association Collections
      ["parent", "ancestors", "belongtos", "neighbors", "siblings", "children"].each do |association|
        define_method(association.to_sym) do |*options|
          xml = self.class.fetch_and_parse(self.class.api_path(self.class.name, @woe_id, association, *options), :select => :long)
          value = xml.search(self.class.name.downcase).collect{|elem| self.class.new(elem)}
          return association.singularize == association ? value.first : value
        end
      end
      
      def to_s
        self.name
      end
      
      def to_i
        self.woe_id.to_i
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

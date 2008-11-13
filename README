= yahoo-geoplanet

A Ruby wrapper for the Yahoo! GeoPlanet APIs.

== Example Usage

=== Searching for a Location:

  require 'yahoo-geoplanet'
  include Yahoo::GeoPlanet
  Yahoo::GeoPlanet.app_id = [Your App ID Here]
  
  # Returns first 20 results by default
  Place.search("Springfield")
  
  # ...but let's say you want _all_ of them
  Place.search("Springfield", :count => 0) # Returns all 110
  
  # You can pass in any Matrix or Query parameters this way too
  # For more details see the following URLs:
  # http://developer.yahoo.com/geo/guide/resources_and_collections.html#matrix_parameters
  # http://developer.yahoo.com/geo/guide/resources_and_collections.html#query_parameters
  
=== Initializing by Where On Earth ID && Associations
  
  require 'yahoo-geoplanet'
  include Yahoo::GeoPlanet
  Yahoo::GeoPlanet.app_id = [Your App ID Here]
  
  cmu = Place.new(23511275) # WoE ID for Carnegie Mellon University
  
  # Everything you get back from the API you have direct access to
  # through the Place object. For example:
  
  puts cmu.type           # "Point of Interest"
  puts cmu.county         # "Allegheny"
  puts cmu.latitude       # 40.444
                          # Latitude and Longitude are values at Centroid
  puts cmu.bounding_box   # [[40.44445, -79.943314], [40.44355, -79.944511]]
                          # Bounding box are NW / SE coordinates in array
  
  # We unlock the true power of GeoPlanet with association collections
  # Check out this truly amazing stuff:
  
  # The containing GeoPlanet entity for CMU
  puts cmu.parent # "Squirrel Hill North"
  
  # A list of other points of interest in the area
  cmu.siblings.each{|s| puts s} 
  
  # A complete hierarchy, from country down to suburb
  cmu.ancestors.each{|s| puts s} 

== REQUIREMENTS:

To use this library, you must have a valid Yahoo! App ID. 
You can get one at http://developer.yahoo.com/wsregapp/

Additionally, yahoo-geoplanet has the following gem dependencies:

* Hpricot >= 0.6
* ActiveSupport >= 2.1.0

== INSTALL:

* sudo gem install yahoo-geoplanet

== LICENSE:

(The MIT License)

Copyright (c) 2008 Mattt Thompson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
Gem::Specification.new do |s|
  s.name     = "yahoo-geoplanet"
  s.version  = "0.2.1"
  s.date     = "2010-03-25"
  s.summary  = "A Ruby wrapper for the Yahoo! GeoPlanet API."
  s.email    = "mail@matttthompson.com"
  s.homepage = "http://github.com/mattt/yahoo-geoplanet/"
  s.description = "A Ruby wrapper for the Yahoo! GeoPlanet API.
                   See http://developer.yahoo.com/geo/ for more information about the API."
  s.authors  = ["Mattt Thompson"]
  
  s.files    = [
    "README", 
    "yahoo-geoplanet.gemspec", 
    "lib/yahoo-geoplanet.rb",
    "lib/rest.rb",
    "lib/yahoo-geoplanet/base.rb",
    "lib/yahoo-geoplanet/place.rb",
    "lib/yahoo-geoplanet/version.rb"
  ]
  
  s.add_dependency("hpricot",       ["> 0.6"])
  s.add_dependency("activesupport", ["> 2.1.0"])
  
  s.has_rdoc = false
  s.rdoc_options = ["--main", "README"]
end

require 'cora'
require 'siri_objects'
require 'pp'
require "net/https"
require "uri"


#######
# Intercepts phrases for turning a light on and off and performs the said action.
######

class SiriProxy::Plugin::Lighting < SiriProxy::Plugin


  def makeRequest(state)
    baseUri = 'http://192.168.2.108:5000/lighting/'
    uri = URI.parse(baseUri + state)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.request(request)
  end

  def initialize(config)
    #if you have custom configuration options, process them here!
  end

  #get the user's location and display it in the logs
  #filters are still in their early stages. Their interface may be modified
  filter "SetRequestOrigin", direction: :from_iphone do |object|
    puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"

    #Note about returns from filters:
    # - Return false to stop the object from being forwarded
    # - Return a Hash to substitute or update the object
    # - Return nil (or anything not a Hash or false) to have the object forwarded (along with any
    #    modifications made to it)
  end

  listen_for /lights on/i do
    say "Turning lights on"
    makeRequest('2')
    request_completed
  end

  listen_for /lights dim/i do
    say "Dimming lights"
    makeRequest('1')
    request_completed
  end

  listen_for /lights off/i do
    say "Turning lights off"
    makeRequest('0')
    request_completed
  end

  listen_for /lights bright/i do
    say "Turning lights on bright"
    makeRequest('3')
    request_completed
  end

end

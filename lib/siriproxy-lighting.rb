require 'cora'
require 'siri_objects'
require 'pp'

#######
# Intercepts phrases for turning a light on and off and performs the said action.
######

class SiriProxy::Plugin::Lighting < SiriProxy::Plugin
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
    # Byte code below will toggle light state for NEC lights. If your light maker is not NEC, then you will need to find out the correct byte code to send.
    # TODO maintain state in this plugin otherwise it will currently continuously toggle between all light states
    system("/usr/bin/printf \"\\x61\\x2\\x20\\x0\\x82\\x6D\\x1A\\xE5\" > /dev/hidraw3")
  end

  listen_for /dim lights/i do
    say "Dimming lights"
  end

  listen_for /lights off/i do
    say "Turning lights off"

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #Demonstrate that you can have Siri say one thing and write another"!
  listen_for /you don't say/i do
    say "Sometimes I don't write what I say", spoken: "Sometimes I don't say what I write"
  end

  #demonstrate state change
  listen_for /siri proxy test state/i do
    set_state :some_state #set a state... this is useful when you want to change how you respond after certain conditions are met!
    say "I set the state, try saying 'confirm state change'"

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  listen_for /confirm state change/i, within_state: :some_state do #this only gets processed if you're within the :some_state state!
    say "State change works fine!"
    set_state nil #clear out the state!

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #demonstrate asking a question
  listen_for /siri proxy test question/i do
    response = ask "Is this thing working?" #ask the user for something

    if(response =~ /yes/i) #process their response
      say "Great!"
    else
      say "You could have just said 'yes'!"
    end

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #demonstrate capturing data from the user (e.x. "Siri proxy number 15")
  listen_for /siri proxy number ([0-9,]*[0-9])/i do |number|
    say "Detected number: #{number}"

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #demonstrate injection of more complex objects without shortcut methods.
  listen_for /test map/i do
    add_views = SiriAddViews.new
    add_views.make_root(last_ref_id)
    map_snippet = SiriMapItemSnippet.new
    map_snippet.items << SiriMapItem.new
    utterance = SiriAssistantUtteranceView.new("Testing map injection!")
    add_views.views << utterance
    add_views.views << map_snippet

    #you can also do "send_object object, target: :guzzoni" in order to send an object to guzzoni
    send_object add_views #send_object takes a hash or a SiriObject object

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
end

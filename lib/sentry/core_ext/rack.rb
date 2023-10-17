require 'rack'

unless Rack.const_defined?('RACK_INPUT')
  module Rack
    RACK_INPUT = 'rack.input'
    RACK_REQUEST_COOKIE_HASH = 'rack.request.cookie_hash'
  end
end

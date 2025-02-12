# src/iot_device_manager.cr

require "http/server"
require "json"

# Define a Device struct
struct Device
  property id : Int32
  property name : String
  property status : String

# In-memory store for devices
@devices = []Device.new

# Create HTTP server
server = HTTP::Server.new do |context|
  request = context.request
  response = context.response

  case request.method
  when "GET"
    response.content_type = "application/json"
    response.print @devices.to_json
  when "POST"
    json = request.body.to_s.to_json
    device = json.to_h.symbolize_keys.as(Device)
    @devices << device
    response.status = 201
    response.content_type = "application/json"
    response.print device.to_json
  when "PATCH"
    # Handle device updates
    device_id = request.path.split("/")[2].to_i
    existing_device = @devices.find { |d| d.id == device_id }

    if existing_device
      updates = request.body.to_s.to_json.to_h.symbolize_keys
      existing_device.name = updates[:name] if updates[:name]
      existing_device.status = updates[:status] if updates[:status]
      response.content_type = "application/json"
      response.print existing_device.to_json
    else
      response.status = 404
      response.print "Device not found"
    end
  else
    response.status = 405
    response.print "Method Not Allowed"
  end
end

# Bind the server to a port
address = "0.0.0.0"
port = 8080
server.bind(address, port)

# Start the server
puts "Listening on http://#{address}:#{port}"
server.listen


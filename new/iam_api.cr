# src/iam_api.cr

require "http/server"
require "json"
require "bcrypt"

# Simple mocked user database
@users = {
  "alice" => BCrypt::Password.create("password123"),
  "bob" => BCrypt::Password.create("qwerty"),
}

# Create HTTP server
server = HTTP::Server.new do |context|
  request = context.request
  response = context.response

  if request.method == "POST" && request.path == "/authenticate"
    # Parse the request body
    json = request.body.to_s.to_json
    credentials = json.to_h.symbolize_keys

    # Authenticate user
    username = credentials[:username]
    password = credentials[:password]

    if @users.has_key?(username) && BCrypt::Password.new(@users[username]) == password
      response.status = 200
      response.print { |io| io << { message: "Authentication successful", username: username }.to_json }
    else
      response.status = 401
      response.print { |io| io << { error: "Invalid credentials" }.to_json }
    end
  else
    response.status = 404
    response.print "Not Found"
  end
end

# Bind the server to a port
address = "0.0.0.0"
port = 8081
server.bind(address, port)

# Start the server
puts "Listening on http://#{address}:#{port}"
server.listen


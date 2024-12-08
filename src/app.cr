# src/app.cr
require "kemal"

get "/" do
  "Hello from Crystal and Kemal!"
end

Kemal.run


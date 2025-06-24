require './app' # This loads both App and BirthdayAPI classes
require 'rack'

# Explicitly map paths to applications
# Requests to /api/... will go to BirthdayAPI
# All other requests will go to App (which handles /view/..., /no_style/...)
application = Rack::URLMap.new({
  "/api" => BirthdayAPI,
  "/"    => App
})

run application

require 'sinatra/base' # Explicitly require sinatra/base
require 'date'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'json'
require 'grape'

# Grape API Definition
class BirthdayAPI < Grape::API
  format :json
  # prefix :api # We will map this path in config.ru using Rack::URLMap

  resource :birthday do
    desc "Returns the number of days since a given birthday."
    params do
      requires :birthday, type: String, desc: "Birthday string (YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS)"
    end
    get do
      begin
        birthday_date = DateTime.parse(params[:birthday])
      rescue ArgumentError
        begin
          birthday_date = Date.parse(params[:birthday])
        rescue ArgumentError
          error!({ error: "Invalid date format. Please use YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS." }, 400)
        end
      end

      birthday_datetime = birthday_date.to_datetime
      days_since = (DateTime.now - birthday_datetime).to_i
      { days_since: days_since }
    end
  end
end

# Sinatra Application for Views
class App < Sinatra::Base
  # Note: No `mount BirthdayAPI` here. This will be handled in config.ru

  helpers do
    def calculate_days_since(birthday_str)
      return nil, "Birthday parameter is missing." unless birthday_str && !birthday_str.empty?

      begin
        birthday_date = DateTime.parse(birthday_str)
      rescue ArgumentError
        begin
          birthday_date = Date.parse(birthday_str)
        rescue ArgumentError
          return nil, "Invalid date format. Please use YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS."
        end
      end

      birthday_datetime = birthday_date.to_datetime
      [(DateTime.now - birthday_datetime).to_i, nil]
    end
  end

  get '/view/birthday' do
    birthday_str = params[:birthday]
    @days_since, @error = calculate_days_since(birthday_str)

    if @error
      status 400
      erb :error_view
    else
      erb :styled_birthday_view
    end
  end

  get '/no_style/birthday' do
    birthday_str = params[:birthday]
    @days_since, @error = calculate_days_since(birthday_str)

    if @error
      status 400
      erb :error_no_style
    else
      erb :no_style_birthday_view
    end
  end

  # Generic error route (optional, for testing error views directly if needed)
  # get '/error' do
  #   @error_message = "A test error occurred."
  #   erb :error_view
  # end
end

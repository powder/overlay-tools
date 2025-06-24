require 'sinatra'
require 'date'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'json'
require 'grape'

# Placeholder for Grape API
class BirthdayAPI < Grape::API
  format :json

  resource :birthday do
    desc "Returns the number of days since a given birthday."
    params do
      requires :birthday, type: String, desc: "Birthday string (YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS)"
    end
    get do
      begin
        # Attempt to parse as DateTime first (YYYY-MM-DDTHH:MM:SS)
        birthday_date = DateTime.parse(params[:birthday])
      rescue ArgumentError
        # If DateTime parsing fails, try parsing as Date (YYYY-MM-DD)
        begin
          birthday_date = Date.parse(params[:birthday])
        rescue ArgumentError
          error!({ error: "Invalid date format. Please use YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS." }, 400)
        end
      end

      # Ensure birthday_date is a DateTime object for consistent comparison
      birthday_datetime = birthday_date.to_datetime

      days_since = (DateTime.now - birthday_datetime).to_i
      { days_since: days_since }
    end
  end
end

# Sinatra application
class App < Sinatra::Base
  # Mount Grape API
  mount BirthdayAPI => '/api'

  helpers do
    def calculate_days_since(birthday_str)
      return nil, "Birthday parameter is missing." unless birthday_str && !birthday_str.empty?

      begin
        # Attempt to parse as DateTime first (YYYY-MM-DDTHH:MM:SS)
        birthday_date = DateTime.parse(birthday_str)
      rescue ArgumentError
        # If DateTime parsing fails, try parsing as Date (YYYY-MM-DD)
        begin
          birthday_date = Date.parse(birthday_str)
        rescue ArgumentError
          return nil, "Invalid date format. Please use YYYY-MM-DD or YYYY-MM-DDTHH:MM:SS."
        end
      end

      # Ensure birthday_date is a DateTime object for consistent comparison
      birthday_datetime = birthday_date.to_datetime

      [(DateTime.now - birthday_datetime).to_i, nil]
    end
  end

  get '/view/birthday' do
    birthday_str = params[:birthday]
    @days_since, @error = calculate_days_since(birthday_str)

    if @error
      status 400
      erb :error_view # You might want to create a specific error view or handle it differently
    else
      erb :styled_birthday_view
    end
  end

  get '/no_style/birthday' do
    birthday_str = params[:birthday]
    @days_since, @error = calculate_days_since(birthday_str)

    if @error
      status 400
      erb :error_no_style # You might want to create a specific error view or handle it differently
    else
      erb :no_style_birthday_view
    end
  end

  # Simple error views
  get '/error' do # A generic error route for demonstration, not used by current logic directly
    @error_message = "An unspecified error occurred."
    erb :error_view
  end
end

# Sinatra will look for views in a 'views' directory
# Create placeholder view files

# To run this app: bundle exec puma config.ru

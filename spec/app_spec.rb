require_relative 'spec_helper'

describe 'Birthday App' do
  include Rack::Test::Methods

  def app
    App # Reference the Sinatra app class directly
  end

  # Freeze time for consistent "days_since" calculation in tests
  let(:current_time) { DateTime.new(2023, 10, 27, 12, 0, 0) } # Example: Oct 27, 2023, 12:00:00

  before do
    allow(DateTime).to receive(:now).and_return(current_time)
  end

  describe 'API Endpoint: /api/birthday' do
    context 'with a valid date (YYYY-MM-DD)' do
      it 'returns the correct number of days' do
        get '/api/birthday?birthday=2023-10-20'
        expect(last_response).to be_ok
        json_response = JSON.parse(last_response.body)
        expect(json_response['days_since']).to eq(7) # 2023-10-27 - 2023-10-20 = 7 days
      end
    end

    context 'with a valid date and time (YYYY-MM-DDTHH:MM:SS)' do
      it 'returns the correct number of days' do
        # Birthday is Oct 26, 2023, 10:00:00. Current time is Oct 27, 2023, 12:00:00
        # This is 1 full day and 2 hours. (DateTime.now - birthday_datetime).to_i truncates.
        get '/api/birthday?birthday=2023-10-26T10:00:00'
        expect(last_response).to be_ok
        json_response = JSON.parse(last_response.body)
        expect(json_response['days_since']).to eq(1)
      end

      it 'returns 0 for a birthday later today' do
        get '/api/birthday?birthday=2023-10-27T10:00:00' # Birthday is today, but earlier
        expect(last_response).to be_ok
        json_response = JSON.parse(last_response.body)
        expect(json_response['days_since']).to eq(0)
      end
    end

    context 'with an invalid date format' do
      it 'returns a 400 error' do
        get '/api/birthday?birthday=invalid-date'
        expect(last_response.status).to eq(400)
        json_response = JSON.parse(last_response.body)
        expect(json_response['error']).to include('Invalid date format')
      end
    end

    context 'with a missing birthday parameter' do
      it 'returns a 400 error (Grape validation)' do
        get '/api/birthday'
        expect(last_response.status).to eq(400) # Grape handles missing required params
        json_response = JSON.parse(last_response.body)
        expect(json_response['error']).to include('birthday is missing')
      end
    end
  end

  describe 'Styled View: /view/birthday' do
    context 'with a valid birthday' do
      it 'renders the styled view with the correct number of days' do
        get '/view/birthday?birthday=2023-10-01' # 26 days before Oct 27
        expect(last_response).to be_ok
        expect(last_response.body).to include('<div class="days-count">26</div>')
        expect(last_response.body).to include('days ago</div>')
      end
    end

    context 'with an invalid birthday' do
      it 'renders the error view' do
        get '/view/birthday?birthday=not-a-date'
        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('<h1>Error</h1>')
        expect(last_response.body).to include('Invalid date format')
      end
    end

    context 'with a missing birthday parameter' do
      it 'renders the error view' do
        get '/view/birthday'
        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('<h1>Error</h1>')
        expect(last_response.body).to include('Birthday parameter is missing')
      end
    end
  end

  describe 'No-Style View: /no_style/birthday' do
    context 'with a valid birthday' do
      it 'renders the no-style view with the correct number of days' do
        get '/no_style/birthday?birthday=2023-09-27' # 30 days before Oct 27
        expect(last_response).to be_ok
        expect(last_response.body).to include('<span class="days-count">30</span>')
        expect(last_response.body).to include('days</span> have passed')
      end
    end

    context 'with an invalid birthday' do
      it 'renders the no-style error view' do
        get '/no_style/birthday?birthday=invalid'
        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('<h1>Error</h1>')
        expect(last_response.body).to include('Invalid date format')
      end
    end

    context 'with a missing birthday parameter' do
      it 'renders the no-style error view' do
        get '/no_style/birthday'
        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('<h1>Error</h1>')
        expect(last_response.body).to include('Birthday parameter is missing')
      end
    end
  end

  # Test the helper method calculate_days_since indirectly via a dummy route if needed,
  # or directly if refactored into its own module/class.
  # For now, its behavior is covered by the route tests.
end

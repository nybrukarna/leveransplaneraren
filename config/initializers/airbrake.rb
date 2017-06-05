if ENV['RACK_ENV'] == 'production'
  require 'airbrake-ruby'

  Airbrake.configure do |c|
    c.project_id = 145594
    c.project_key = '03c4650fcca3388696ba23ba1bbd2efe'
  end
end

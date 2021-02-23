require 'rspec'
require 'pg'
require 'pry'

DB = PG.connect({ dbname: 'record_store_test', host: 'db', user: 'postgres', password: 'password' })

RSpec.configure do |config|
  config.after(:each) do
    # Add code to clear database.
  end
end

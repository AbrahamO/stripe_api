# frozen_string_literal: true

require 'stripe'
require 'csv'

MAX_RETRIES = 20
Stripe.api_key = ENV[STRIPE_API_KEY]

def set_starting_point
  @last_id = nil
  @retries = 0
  return unless File.file?('customers.csv')

  parsed_csv = CSV.parse(File.read('customers.csv'))
  @last_id = parsed_csv[-1][0]
end

def fetch_customers
  client = Stripe::StripeClient.new
  body, response = client.request do
    Stripe::Customer.list({ limit: 50, starting_after: @last_id })
  end
  handle_rate_limit if response.http_status == 429
  @retries = 0

  body
end

def handle_rate_limit
  raise "You've hit the rate limit" unless @retries <= MAX_RETRIES

  @retries += 1
  sleep 2**@retries
  fetch_customers
end

def append_customers(customers)
  CSV.open('customers.csv', 'a+') do |csv|
    customers.each do |customer|
      csv << [customer['id'], customer['account_balance'], customer['created']]
    end
  end
end

loop do
  set_starting_point

  response = fetch_customers
  append_customers(response['data'])

  break unless response['has_more']
end

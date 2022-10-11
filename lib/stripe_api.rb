# frozen_string_literal: true

require 'stripe'

class StripeApi
  MAX_RETRIES = 10

  def initialize
    Stripe.api_key = ENV.fetch('STRIPE_API_KEY')
  end

  def list_customers(limit:, starting_after:)
    api_request = OpenStruct.new(retry?: true, retries: 0)
    result = nil

    while api_request.retry?
      begin
        result = Stripe::Customer.list({ limit:, starting_after: })
        api_request[:retry?] = false
      rescue Stripe::RateLimitError
        api_request.retries += 1
        raise Stripe::RateLimitError if api_request.retries > MAX_RETRIES

        sleep api_request.retries**2
      end
    end
    result
  end
end

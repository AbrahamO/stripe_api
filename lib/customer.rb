# frozen_string_literal: true

require_relative './stripe_api'

class Customer
  class << self
    def all(starting_after: nil)
      customers = []
      last_batch = OpenStruct.new(has_more?: true)
      while last_batch.has_more?
        last_batch = list(starting_after: last_batch.instance_of?(OpenStruct) ? starting_after : customers.last.id)
        last_batch.data.each do |customer|
          customers << customer
        end
      end
      customers
    end

    private

    def list(limit: 50, starting_after: nil)
      client.list_customers(limit:, starting_after:)
    end

    def client
      @client ||= StripeApi.new
    end
  end
end

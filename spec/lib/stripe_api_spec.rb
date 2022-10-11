# frozen_string_literal: true

require 'stripe_api'
require 'stripe'

describe StripeApi do
  describe '#list_customers' do
    subject(:client) { described_class.new }

    context 'when hitting rate limit' do
      before do
        allow(Stripe::Customer).to receive(:list).and_raise(Stripe::RateLimitError)
        stub_const('StripeApi::MAX_RETRIES', 1)
      end

      let(:response) { client.list_customers(limit: 10, starting_after: nil) }

      it 'raises an error after reaching the retry limit' do
        expect { response }.to raise_error(Stripe::RateLimitError)
      end
    end

    context 'when succesful request' do
      before do
        stub_request(:get, 'https://api.stripe.com/v1/customers?limit=10')
          .to_return(status: 200, body: expected_response.to_json)
      end

      let(:response) { client.list_customers(limit: 10, starting_after: nil) }
      let(:expected_response) do
        {
          data: [
            { id: 'cus_one', account_balance: '0' },
            { id: 'cus_two', account_balance: '10' }
          ],
          has_more: false
        }.to_json
      end

      it 'returns expected response' do
        expect(response).to eq(expected_response)
      end
    end
  end
end

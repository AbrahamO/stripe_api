# frozen_string_literal: true

require 'customer'

describe Customer do
  before do
    stub_request(:get, 'https://api.stripe.com/v1/customers?limit=50')
      .to_return(status: 200, body: api_response.to_json)
  end

  let(:api_response) do
    {
      data: [
        { id: 'cus_one', account_balance: '0' },
        { id: 'cus_two', account_balance: '10' }
      ],
      has_more: false
    }
  end
  let(:expected_response) { api_response[:data].to_json }
  let(:response) { described_class.all.to_json }

  describe '.all' do
    it 'returns an array of customers' do
      expect(response).to eq(expected_response)
    end
  end
end

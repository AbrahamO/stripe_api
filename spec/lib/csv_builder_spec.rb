# frozen_string_literal: true

require 'csv_builder'

describe CsvBuilder do
  before { described_class.build(path: file_path, records:) }
  after { File.delete(file_path) }

  let(:file_path) { 'test.csv' }
  let(:records) do
    [
      double('customer_one', id: 'cus_one', account_balance: '0', created: 'now'),
      double('customer_two', id: 'cus_two', account_balance: '10', created: 'yesterday')
    ]
  end
  let(:expected_content) { [%w[cus_one 0 now], %w[cus_two 10 yesterday]] }

  describe '.build' do
    it 'appends records to the CSV file' do
      expect(CSV.open(file_path).readlines).to eq(expected_content)
    end
  end
end

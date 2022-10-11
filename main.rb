# frozen_string_literal: true

require_relative './lib/customer'
require_relative './lib/csv_builder'

CSV_FILE_PATH = '/tmp'
CSV_FILENAME = 'customer.csv'
FULL_PATH = "#{CSV_FILE_PATH}/#{CSV_FILENAME}".freeze

def last_record
  CSV.parse(File.read(FULL_PATH))[-1][0] if File.file?(FULL_PATH)
end

customers = Customer.all(starting_after: last_record)
CsvBuilder.build(path: FULL_PATH, records: customers)

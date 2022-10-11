# frozen_string_literal: true

require 'csv'

class CsvBuilder
  class << self
    def build(path:, records:, mode: 'a+')
      CSV.open(path, mode) do |csv|
        records.each do |record|
          csv << [record.id, record.account_balance, record.created]
        end
      end
    end
  end
end

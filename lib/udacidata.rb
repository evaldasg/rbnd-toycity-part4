require_relative 'find_by'
require_relative 'errors'
require 'csv'
require 'byebug'

class Udacidata
  # Your code goes here!

  class << self
    def create(attrs = nil)
      # If the object's data is already in the database
      # create the object
      # return the object

      # If the object's data is not in the database
      # create the object
      # save the data in the database
      # return the object
      object = new(attrs)
      CSV.open(data_path, 'a+') do |csv|
        csv << object.instance_variables.map { |variable| object.instance_variable_get(variable) }
      end
      object
    end

    def all
      # TODO: when create method will not create duplicates on DB
      #   then change here Product to create method call
      array = []
      CSV.foreach(data_path, headers: true) do |row|
        array << Product.new(row.to_hash)
      end
      array
    end

    def first(n = 1)
      return first_csv_row if n == 1
      frist_n_csv_rows(n)
    end

    private

    def data_path
      @data_path ||= File.expand_path('./data/data.csv')
    end

    def first_csv_row
      attrs = CSV.open(data_path, headers: true, &:first).to_hash
      Product.new(attrs)
    end

    def frist_n_csv_rows(n)
      csv = CSV.read(data_path, headers: true).first(n)
      csv.map { |row| Product.new(row.to_hash) }
    end
  end
end

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

    def first
      attrs = CSV.open(data_path, headers: true, &:first).to_hash
      Product.new(attrs)
    end
  end

  private

  def data_path
    @data_path ||= File.expand_path('./data/data.csv')
  end
end

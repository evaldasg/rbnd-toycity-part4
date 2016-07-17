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
      @data_path = File.expand_path('./data/data.csv')
      CSV.open(@data_path, 'a+') do |csv|
        csv << object.instance_variables.map { |var| object.instance_variable_get(var) }
      end
      object
    end
  end
end

require_relative 'find_by'
require_relative 'errors'
require 'csv'
require 'byebug'

class Udacidata
  # Your code goes here!

  def update(attrs = {})
    attrs.keys.each { |key| instance_variable_set("@#{key}", attrs[key]) if instance_variable_defined?("@#{key}") }
    update_in_db(attrs)
    self
  end

  def to_hash
    instance_variables.each_with_object({}) do |variable, hash|
      hash[variable.to_s.delete('@').to_sym] = instance_variable_get(variable)
    end
  end

  private

  def update_in_db(attrs)
    csv_data = CSV.table(data_path, headers: true)
    csv_row = csv_data.detect { |row| row[:id] == self.id } # rubocop:disable Style/RedundantSelf
    attrs.keys.each { |key| csv_row[key] = attrs[key] }
    File.open(data_path, 'w') { |file| file.write(csv_data.to_csv) }
  end

  def data_path
    self.class.send(:data_path)
  end

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

    # Here I'll be using this tool:
    #   wc (short for word count) is a command in Unix-like operating systems.
    #   wc -l <filename> prints the line count (note that if the last line does not have \n, it will not be counted)
    #   line_count variable will store value of lines number in data.csv
    #   drop_lines variable is line_count - 1 (for headers) - n (for actual line number that we'll leave)
    #   csv variable is enumarator wich will drop drop_lines number of rows, and return array with
    #     the last row entry only; this helps to avoid array initialization in memory
    def last(n = 1)
      line_count = `wc -l #{data_path}`.to_i
      drop_lines = line_count - 1 - n
      csv = CSV.foreach(data_path, headers: true)
      last_lines = csv.drop(drop_lines).first(n).map { |row| Product.new(row.to_hash) }
      n == 1 ? last_lines[0] : last_lines
    end

    def find(id)
      csv_data = CSV.table(data_path, headers: true)
      attrs = csv_data.detect { |row| row[:id] == id }
      Product.new(attrs.to_hash)
    end

    def destroy(id)
      deleted_object = ''
      csv_data = CSV.table(data_path, headers: true)
      csv_data.delete_if { |row| row[:id] == id && deleted_object = Product.new(row.to_hash) }
      File.open(data_path, 'w') { |file| file.write(csv_data.to_csv) }
      deleted_object
    end

    def find_by_brand(value)
      csv_data = CSV.table(data_path, headers: true)
      attrs = csv_data.detect { |row| row[:brand] == value }
      Product.new(attrs.to_hash)
    end

    def find_by_name(value)
      csv_data = CSV.table(data_path, headers: true)
      attrs = csv_data.detect { |row| row[:name] == value }
      Product.new(attrs.to_hash)
    end

    def where(options = {})
      keys = options.keys
      csv = CSV.foreach(data_path, headers: true)
      selected_rows = csv.select do |row|
        should_select = false
        keys.each do |key|
          should_select = true if row[key.to_s] == options[key]
        end
        should_select
      end
      selected_rows.map { |row| Product.new(row.to_hash) }
    end

    private

    def data_path
      @data_path ||= File.expand_path('./data/data.csv')
    end

    def first_csv_row
      attrs = CSV.foreach(data_path, headers: true).first.to_hash
      Product.new(attrs)
    end

    def frist_n_csv_rows(n)
      csv = CSV.foreach(data_path, headers: true).first(n)
      csv.map { |row| Product.new(row.to_hash) }
    end
  end
end

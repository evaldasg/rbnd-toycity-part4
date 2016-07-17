require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def data_path
  File.expand_path('./data/data.csv')
end

def attrs(id)
  {
    id: id,
    brand: Faker::Company.name,
    name: Faker::Commerce.product_name,
    price: Faker::Commerce.price,
  }
end

def db_seed
  CSV.open(data_path, 'a+') do |csv|
    10.times do |i|
      product = Product.new(attrs(i + 1))
      csv << product.instance_variables.map { |variable| product.instance_variable_get(variable) }
    end
  end
end

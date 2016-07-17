require 'hirb'
require 'colorize'

Hirb::View.enable
Hirb::Helpers::Table::Filters.module_eval(%q{def add_currency(val) "$ #{val}" end})

module Analyzable
  def average_price(array)
    (array.map(&:price).map(&:to_f).inject(:+) / array.size).round(2)
  end

  def print_report(objects)
    ::Hirb::Helpers::Table.render(
      objects.map(&:to_hash),
      fields: [:id, :brand, :name, :price],
      headers: { id: 'ID', brand: 'Brand', name: 'Name', price: 'Price' },
      filters: { price: :add_currency },
    ).yellow
  end

  def count_by_brand(objects)
    { objects[0].brand => objects.size }
  end

  def count_by_name(objects)
    { objects[0].name => objects.size }
  end
end

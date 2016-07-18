require_relative 'count_by'
require 'hirb'
require 'colorize'

Hirb::View.enable
Hirb::Helpers::Table::Filters.module_eval(%q{def add_currency(val) "$ #{val}" end})

module Analyzable
  create_counter_methods :brand, :name

  def average_price(array)
    average(:price, array)
  end

  def print_report(objects)
    report = ''
    report << "Average Price: $#{average_price(objects)}\n"
    report << "Inventory by Brand:\n"
    count_by_brand(objects).each { |brand, counted| report << "  - #{brand.to_s.capitalize}: #{counted}\n" }
    report << "Inventory by Name:\n"
    count_by_name(objects).each { |brand, counted| report << "  - #{brand.to_s.capitalize}: #{counted}\n" }
    report.yellow
  end

  def print_report_in_table(objects)
    ::Hirb::Helpers::Table.render(
      objects.map(&:to_hash),
      fields: [:id, :brand, :name, :price],
      headers: { id: 'ID', brand: 'Brand', name: 'Name', price: 'Price' },
      filters: { price: :add_currency },
    ).yellow
  end

  private

  def average(attribute, items, round = 2)
    sum = items.map { |item| item.send(attribute).to_f }.reduce(:+)
    (sum / items.size).round(round)
  end
end

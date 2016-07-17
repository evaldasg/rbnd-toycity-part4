module Analyzable
  def average_price(array)
    (array.map(&:price).map(&:to_f).inject(:+) / array.size).round(2)
  end
end

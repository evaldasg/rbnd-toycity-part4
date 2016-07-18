class Module
  def create_finder_methods(*attributes)
    attributes.each do |name|
      finder_method = %{
        def find_by_#{name}(value)
          csv_data = CSV.table(data_path, headers: true)
          attrs = csv_data.detect { |row| row[:#{name}] == value }
          Product.new(attrs.to_hash)
        end
      }
      module_eval(finder_method)
    end
  end
end

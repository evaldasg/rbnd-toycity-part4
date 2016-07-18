class Module
  def create_counter_methods(*attributes)
    attributes.each do |name|
      counter_method = %{
        def count_by_#{name}(objects)
          objects.each_with_object(Hash.new(0)) do |object, hash|
            hash[object.#{name}] += 1
          end
        end
      }
      module_eval(counter_method)
    end
  end
end

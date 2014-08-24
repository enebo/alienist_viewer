module InstancesHelper
  def data_value(instance, nest=0)
    str = if instance.cls.name == "Array"
            elements = if nest < 1
              instance.data.map do |e|
                instance = Memory.instance.find_by_id(e.to_i)
                link_to data_value(instance, nest + 1), instance_path(instance)
              end
            else
              instance.data.map do |e|
                instance = Memory.instance.find_by_id(e.to_i)
                link_to instance.display_value, instance_path(instance)
              end
            end
            "[" + elements.join(", ") + "] (#{elements.size})"
          else
            instance.display_name
          end

    str.html_safe
  end
end

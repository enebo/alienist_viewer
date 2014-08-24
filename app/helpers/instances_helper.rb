module InstancesHelper
  def data_value(instance, nest=0)
    str = if instance.cls.name == "Array"
            elements = if nest > 0
              instance.data.map do |e|
                instance_link(e, data_value(Memory.instance.find_by_id(e.to_i), nest + 1))
              end
            else
              instance.data.map { |e| instance_link(e) }
            end
            "[" + elements.join(", ") + "] (#{elements.size})"
          else
            instance.display_value
          end

    str.html_safe
  end

  def instance_link(id, label=nil)
    label = "&lt;0x#{id.to_i.to_s(16)}&gt;" unless label
    %Q{<a href="#{instances_path}/#{id}">#{label}</a>}.html_safe
  end
end

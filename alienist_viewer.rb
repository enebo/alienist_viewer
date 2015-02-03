require 'roda'
%w'ruby_instance false_instance nil_instance array_instance ruby_class string_instance true_instance memory'.each{|f| require "./models/#{f}"}

class AlienistViewer < Roda
  use Rack::Static, :urls=>['/app.css'], :root=>'public'
  plugin :render, :escape=>true, :cache=>(ENV['RACK_ENV'] != 'development')
  plugin :symbol_views
  plugin :path
  plugin :h

  path(:class){|c| "/class/#{c.id}"}
  path(:instance){|i| "/instance/#{i.id}"}

  plugin :not_found do
    view(:content=>'<h1>File Not Found</h1>')
  end
  plugin :error_handler do |e|
    if e.is_a?(Memory::NoObject)
      response.status = 404
      view(:content=>'<h1>File Not Found</h1>')
    else
      puts "#{e.class}: #{e.message}", e.backtrace
      view(:content=>'<h1>Internal Server Error</h1>')
    end
  end


  route do |r|
    r.get do
      r.is '' do
        @classes = Memory.instance.classes
        :index
      end

      r.is 'class/:d' do |class_id|
        @class = Memory.instance.find_by_id!(class_id.to_i)
        :class
      end

      r.is 'instance/:d' do |instance_id|
        @instance = Memory.instance.find_by_id!(instance_id.to_i)
        :instance
      end
    end
  end

  private

  def instance_link(instance, nest=0)
    if instance.is_a?(ArrayInstance)
      nested = nest < 1
      elements = instance.data.map do |e|
        ins = Memory.instance.find_by_id(e.to_i)
        if ins.is_a?(RubyClass)
          "<a href=\"#{class_path(ins)}\">#{h ins.name}</a>"
        elsif ins
          "<a href=\"#{instance_path(ins)}\">#{nested ? instance_link(ins, nest + 1) : h(ins.display_name)}</a>"
        end
      end
      "[#{elements.join(", ")}] (#{elements.size})"
    else
      "<a href=\"#{instance_path(instance)}\">#{h instance.display_name}</a>"
    end
  end
end

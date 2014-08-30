require "json"

class Memory

  def self.instance
    load unless defined? @@memory
    @@memory
  end

  def self.load(filename='data.json')
    @@memory = Memory.new filename
    @@memory.process_dump
  end
  
  def initialize(filename)
    @classes_by_name = {}
    @all_by_id = {}
    @filename = filename
  end

  def classes
    @classes_by_name.values
  end

  def find_by_id(id)
    @all_by_id[id]
  end

  def process_dump
    data = JSON.load File.read(@filename)

    data.each do |cls_hash|
      name = cls_hash["name"]
      id = cls_hash["id"]
      cls = RubyClass.new id, name, cls_hash["size"]
      @classes_by_name[name] = cls
      @all_by_id[id] = cls

      if cls_hash["instances"]
        cls_hash["instances"].each do |inst_hash|
          iid = inst_hash['id']
          size = inst_hash['size']
          data = inst_hash['data']
          variables = inst_hash['variables']
          referers = inst_hash['references']
          instance = create_ruby_instance(iid, cls, size, data, variables, referers)
          @all_by_id[iid] = instance
          cls.add instance
        end
      end
    end
    # puts "Ruby Classes: #{@classes_by_name.values.length}, Ruby Instances: #{@all_by_id.values.length}"
  end

  # def inspect
  #   @classes_by_name.values.each do |cls|
  #     puts "CLS: #{cls.name}"
  #     puts "  INSTANCES:"
  #     cls.instances.each do |instance|
  #       puts "    ID: #{instance.id}"
  #       puts "    DATA: #{instance.data}" if instance.data
  #       puts "    VARS: #{resolve(instance.variables)}" if instance.variables
  #     end
  #   end
  # end

  def resolve(variables)
    nice_vars = []
    variables.each { |name, ref| nice_vars << [name, @all_by_id[ref]] }
    nice_vars
  end

  # Map the class name string to the correct model.
  TYPE_MAPPINGS = {
    'NilClass' => NilInstance,
    'FalseClass' => FalseInstance,
    'TrueClass' => TrueInstance,
    'String' => StringInstance,
  }

  def create_ruby_instance(iid, cls, size, data, variables, referers)
    instance_class = TYPE_MAPPINGS[cls.name] || RubyInstance
    instance_class.new(iid, cls, size, data, variables, referers)
  end

end

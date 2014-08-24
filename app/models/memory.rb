require "json"

class Memory
  def self.instance
    @@memory ||= load # HAR.  Don't get initiaizers in dev mode
  end
  def self.load
    @@memory = Memory.new
    @@memory.process_dump
  end
  
  def initialize
    @classes_by_name = {}
    @all_by_id = {}
  end

  def classes
    @classes_by_name.values
  end

  def find_by_id(id)
    @all_by_id[id]
  end

  def process_dump
    data = JSON.load File.read("data.json")

    data.each do |cls_hash|
      name = cls_hash["name"]
      id = cls_hash["id"]
      cls = RubyClass.new id, name, cls_hash["size"]
      @classes_by_name[name] = cls
      @all_by_id[id] = cls

      cls_hash["instances"].each do |inst_hash|
        iid = inst_hash['id']
        size = inst_hash['size']
        data = inst_hash['data']
        variables = inst_hash['variables']
        referers = inst_hash['references']
        instance = RubyInstance.new iid, cls, size, data, variables, referers
        @all_by_id[iid] = instance
        cls.add instance
      end
    end
    puts "Ruby Classes: #{@classes_by_name.values.length}, Ruby Instances: #{@all_by_id.values.length}"
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
end

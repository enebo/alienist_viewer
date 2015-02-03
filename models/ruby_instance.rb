class RubyInstance
  attr_reader :id, :cls, :size, :data, :variables, :referers

  def initialize(id, cls, size, data=nil, variables=nil, referers=nil)
    @id, @cls, @size = id, cls, size
    @data, @variables, @referers = data, variables, referers
  end

  def display_name
    display_use_data? ? @data.to_s : "#[#{@cls.name}: 0x#{@id.to_s(16)}]"
  end

  private

  def display_use_data?
    !@data.to_s.empty?
  end
end

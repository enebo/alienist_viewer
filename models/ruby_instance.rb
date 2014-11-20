class RubyInstance
  attr_reader :id, :cls, :size, :data, :variables, :referers

  def initialize(id, cls, size, data=nil, variables=nil, referers=nil)
    @id, @cls, @size = id, cls, size
    @data, @variables, @referers = data, variables, referers
  end

  def to_param
    id.to_s
  end

  def display_name
    "#[#{@cls.name}: 0x#{@id.to_s(16)}]"
  end

  def display_value
    display_name
  end

end

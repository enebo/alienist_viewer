class StringInstance < RubyInstance

  def display_name
    '"' + @data + '"'
  end

end

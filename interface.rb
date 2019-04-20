module Interface
  def puts_separator(mark='-', length=40)
    length.times do
      print mark
    end

    print "\n"
  end
end

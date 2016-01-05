class Memo < Post

  def read_from_console
    puts "Новая заметка (введите \"end\",чтобы закончить ввод"
    @text=[]
    line = nil
    while line != "end" do
      line = STDIN.gets.chomp
      @text << line
    end

    @text.pop
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d,%H:%M:%S")}"

    return @text.unshift(time_string)
  end

  def to_db_hash
    return super.merge(
                    {
                        'text' => @text.join('\n\r')
                    }
    )
  end

  def load_data(data_hash)
    super(data_hash)
    @text = data_hash['text'].split('\n\r')

  end
end
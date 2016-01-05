if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.local_charmap)
  Encoding.default_internal=__ENCODING__

  [STDIN,STDOUT].each do |io|
    io.set_encoding(Encoding.default_external,Encoding.default_internal)
  end
end

require_relative 'post.rb'
require_relative 'link.rb'
require_relative 'memo.rb'
require_relative 'task.rb'

#id,limit,type

require 'optparse'

options = {}

OptionParser.new do |opt|
  opt.banner = "Usage: read.rb [options]"

  opt.on('-h', 'Print this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE','какой тип постов показывать (по умолчанию любой)'){|o| options[:type] = o}
  opt.on('--id POST_ID','если задан id - показываем подробно только этот пост'){|o| options[:id] = o}
  opt.on('--limit NUMBER','сколько последних постов показать(по умолчанию все'){|o| options[:limit] = o}
end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

if result.is_a?(Post)
  puts "Запись #{result.class.name}, id= #{options[:id]}"

  result.to_strings.each do |line|
    puts line
  end

else
  print "| id\t| @type | @created_at\t\t\t| @text\t\t\t| @url\t\t| @due_date \t"

  result.each do |row|
    puts
    row.each do |element|
      print "| #{element.to_s.delete("\\n\\r")[0..40]}\t"
    end
  end
end

puts
require 'sqlite3'

class Post

  @@SQLITE_DB_FILE='notepad.sqlite'

  def self.post_types
    {'Link'=>Link,'Memo'=>Memo, 'Task'=>Task}
  end

  def self.create(type)
    return post_types[type].new
  end

  def initialize
    @created_at = Time.now
    @text = nil
  end

  def read_from_console
    #todo
  end

  def to_strings
    #todo
  end

  def save
    file = File.new(file_path,"w:UTF-8")
    for item in to_strings do
      file.puts(item)
    end

    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")
    return current_path + "/" + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true
    db.execute(
          "INSERT INTO posts (" +
              to_db_hash.keys.join(',') +
              ")" +
              "VALUES (" +
              ('?,' * to_db_hash.keys.size).chomp(',') +
              ")",
          to_db_hash.values

    )
    insert_row_id = db.last_insert_row_id
    db.close
    return insert_row_id
  end

  def to_db_hash
    {
        'type' => self.class.name,
        'created_at' => @created_at.to_s
    }
  end
end

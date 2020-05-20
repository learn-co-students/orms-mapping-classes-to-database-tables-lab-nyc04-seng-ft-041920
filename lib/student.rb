class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students( 
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT);"
      # Creates students table if it does not exist

    DB[:conn].execute(sql)  # Connects to database and executes above code
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;" # If table students exists then drop the table
    DB[:conn].execute(sql)                 # Connects to the database then executes code above via sqllite.
  end

  def save
    sql = "INSERT INTO students(name, grade) VALUES (?, ?);"
    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT * 
    FROM students
    WHERE ID = (SELECT MAX(ID)  FROM students);").flatten[0]
    # binding.pry
    #save::
  end

  def self.create(args)
    new_student = Student.new(args[:name], args[:grade])
    new_student.save
    new_student
  end

end

=begin
## Save::
https://stackoverflow.com/questions/30994897/how-to-get-last-inserted-row-in-sqlite-android
  1.  @id = DB[:conn].execute("SELECT * 
    directly connects to the database via sqllite then Selects all of the columns
    It stores the value directly into the <Instance Variable :: id>
  
  2.  FROM students
    This takes all of the columns from <Table :: students>
  
  3.  WHERE ID = (SELECT MAX(ID)  FROM students);").flatten[0]
    Sets the condition so it only grabs the column from the <Instance Variable :: id> with the greatest value
    The value that is ouputted is an array of arrays with a single element.
    So we must flatten it in order to manipulate the data and then call the first index [0]
    in order to grab the <Instance Variable :: id>
=end
class Student
  # Remember, you can access your database connection anywhere in this class with DB[:conn]
  attr_reader :id
  attr_accessor :name, :grade

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    sql = "INSERT INTO students (name, grade) VALUES (?,?);"
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("select id from students where name = ?;", self.name).flatten[0]
    self
  end

  def self.create(arg_hash)
    student = Student.new(arg_hash[:name], arg_hash[:grade])
    student.save
    student
  end
end

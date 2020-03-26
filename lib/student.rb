class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
    # create a new Student object given a row from the database
  end

  def self.all

    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).each do |row|
      self.new_from_db(row)
  end

  def self.find_by_name(name)

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    DB[:conn].execute(sql, name).map do |names|
      self.new_from_db(names)
    end.first
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

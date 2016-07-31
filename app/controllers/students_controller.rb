class StudentsController < ApplicationController
  def index
    
  end

  def new
    @student = Student.new()
    @student.class_students.build(year: ClassStudent.current_year)
    @student.parents.build
  end
end

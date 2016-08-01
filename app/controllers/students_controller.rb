class StudentsController < ApplicationController
  def index
    @tab = TabConstants::STUDENTS
  end

  def new
    @tab = TabConstants::STUDENTS
    @student = Student.new()
    @student.student_years.build(academic_year: StudentYear.current_year)
    @student.parents.build
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to students_path, notice: 'Student was successfully created.'
    else
      render :new
    end
  end

  def show
    set_student_and_tab
  end

  def edit
    set_student_and_tab
  end

  private

  def set_student_and_tab
    @student = Student.find(params[:id])
    @tab = TabConstants::STUDENTS
  end

  def student_params
    params.require(:student).permit(:first_name, :middle_name, :last_name, :phone, :date_of_birth, :gender, :caste, :joined_on, student_years_attributes: [:id, :academic_year, :branch, :section, :classroom], parents_attributes: [:id, :name, :phone, :relation, :_destroy ])
    end
end

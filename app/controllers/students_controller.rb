class StudentsController < ApplicationController
  def index
    @tab = TabConstants::STUDENTS
    @students = Student.current.includes(:student_years, :parents).page(params[:page]).per_page(20)
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
    #TBD
  end

  def update
    #TBD
  end

  def destroy
    #TBD
  end

  private

  def set_student_and_tab
    @student = Student.find(params[:id])
    @tab = TabConstants::STUDENTS
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :aadhar_number, :phone, :email, :date_of_birth, 
      :gender, :mother_tounge, :caste, :religion, :ward_type, :disability, :address, 
      :joined_on, :admission_number, :joined_class,
      student_years_attributes: [:id, :academic_year, :branch, :section, :classroom, :roll_number, :fees_payed], 
      parents_attributes: [:id, :name, :phone, :relation, :email, :income, :qualification, :occupation, :_destroy ])
    end
end

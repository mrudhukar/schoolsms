class StudentsController < ApplicationController

  def dashboard
    @tab = TabConstants::DASHBOARD
  end

  def index
    @tab = TabConstants::STUDENTS
    default_filters = {with_academic_year: StudentYear.current_year, with_status: Student::Status::ACTIVE}
    all_filters = (params[:filterrific] || {}).merge(default_filters)

    @filterrific = initialize_filterrific(
      Student,
      all_filters,
    ) or return
    @students = @filterrific.find.includes(:student_years).page(params[:page]).per_page(20)

    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
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
      render :new, error: "Please fix the erors"
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

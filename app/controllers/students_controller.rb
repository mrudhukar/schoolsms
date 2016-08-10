class StudentsController < ApplicationController

  def dashboard
    @tab = TabConstants::DASHBOARD
    @students_count = Student.with_academic_year(StudentYear.current_year).count
    lastyear_count = Student.with_academic_year(StudentYear.current_year - 1).count
    @student_increase = (@students_count - lastyear_count)/lastyear_count.to_f if lastyear_count > 0
    @sms_balance = Message.get_current_balance()
    @last_message = Message.last
  end

  def index
    @tab = TabConstants::STUDENTS
    all_filters = (params[:filterrific] || {}).merge({with_status: Student::Status::ACTIVE})
    all_filters[:with_academic_year] = StudentYear.current_year if all_filters[:with_academic_year].blank?

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
    @student = Student.new(student_create_params)
    if @student.save
      redirect_to students_path, notice: 'Student was successfully created.'
    else
      render :new, alert: "Please fix the errors"
    end
  end

  def show
    set_student_and_tab
  end

  def edit
    set_student_and_tab
    @is_edit_class = (params[:syear] == "true")
    @student_year = @student.student_years.new(academic_year: StudentYear.current_year) if @is_edit_class
  end

  def update
    set_student_and_tab
    if @student.update(profile_update_params)
      redirect_to @student, notice: 'Student was successfully updated.'
    else
      render :edit, alert: "Please fix the errors"
    end
  end

  def update_class
    set_student_and_tab
    @is_edit_class = true

    @student_year = @student.student_years.new(student_year_params)
    if @student_year.save
      redirect_to students_path, notice: "Student's class was successfully created."
    else
      render :edit, alert: "Please fix the errors"
    end
  end

  def destroy
    set_student_and_tab
    @student.destroy
    redirect_to students_url, notice: 'Student was successfully removed.'
  end

  def import
    @tab = TabConstants::IMPORT
    if request.get?
      @import_student = ImportStudent.new
    else
      #POST
      unless params[:import_student]
        redirect_to import_students_path, alert: "Please select a file"
        return
      end

      @import_student = ImportStudent.new(params[:import_student])
      if @import_student.save
        redirect_to students_path(), notice: "Imported student records successfully."
      else
        redirect_to import_students_path, alert: "#{@import_student.errors.full_messages.join}"
      end
    end
  end

  private

  def set_student_and_tab
    @student = Student.find(params[:id])
    @tab = TabConstants::STUDENTS
  end

  def profile_params
    [
      :first_name, :last_name, :aadhar_number, :phone, :email, :date_of_birth, 
      :gender, :mother_tounge, :caste, :religion, :ward_type, :disability, :address, 
      :joined_on, :admission_number, :joined_class, 
      parents_attributes: [:id, :name, :phone, :relation, :email, :income, :qualification, :occupation, :_destroy ]
    ]
  end

  def profile_update_params
    params.require(:student).permit(profile_params)
  end

  def student_create_params
    all_params = profile_params
    all_params << {student_years_attributes: [:id, :medium, :academic_year, :branch, :section, :classroom, :roll_number, :fees_payed]}
    params.require(:student).permit(all_params)
  end

  def student_year_params
    params.require(:student_year).permit(:academic_year, :medium, :branch, :section, :classroom, :roll_number, :fees_payed)
  end
end

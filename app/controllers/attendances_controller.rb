class AttendancesController < ApplicationController
  before_action :set_month_and_tab

  def index
    @start_date = params[:start_date].try(:to_date) || session[:start_date].try(:to_date) || Date.today
    session[:start_date] = @start_date

    @date_range = @start_date.beginning_of_week().. @start_date.end_of_week()

    get_objects(params[:filterrific] || {})
    @filterrific = initialize_filterrific(Student, @all_filters) or return

    @students = @filterrific.find
    @student_years = StudentYear.where(academic_year: StudentYear.current_year, student_id: @students.collect(&:id)).includes(:student)
    @attendances = Attendance.where(student_year_id: @student_years.collect(&:id), absent_on: @date_range).group_by(&:student_year_id)


    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def create
    @student_year = StudentYear.find(params[:syid])
    date = params[:day].to_date
    attendance = @student_year.attendances.where(absent_on: date).first 
    if params[:abtype].present?
      if attendance
        attendance.update_attribute(absent_type: params[:abtype].to_i)
      else
        @student_year.attendances.create!(absent_on: date, absent_type: params[:abtype])
      end
    elsif params[:present] == "true"
      attendance.destroy
    end

    date_range = date.beginning_of_week().. date.end_of_week()
    @student_atts = @student_year.attendances.where(absent_on: date_range)

    redirect_to attendances_path()
  end

  private

  def set_month_and_tab
    @tab = TabConstants::ATTENDANCE
  end

  def get_objects(filters)
    @all_filters = filters.merge({with_status: Student::Status::ACTIVE, with_academic_year: StudentYear.current_year})

    @all_filters[:with_branch] = @all_filters[:with_branch].presence || session[:with_branch]
    @all_filters[:with_medium] = @all_filters[:with_medium].presence || session[:with_medium]
    @all_filters[:with_klass]  = @all_filters[:with_klass].presence || session[:with_klass]
    @all_filters[:with_sections] = @all_filters[:with_sections].presence || session[:with_sections]

    session[:with_branch] = @all_filters[:with_branch]
    session[:with_medium] = @all_filters[:with_medium]
    session[:with_klass] = @all_filters[:with_klass]
    session[:with_sections] = @all_filters[:with_sections]

    @show_attendance = @all_filters[:with_branch].present? && @all_filters[:with_medium].present? && @all_filters[:with_klass].present? && @all_filters[:with_sections].present?
  end
end

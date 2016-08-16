class ImportStudent
  extend ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_students.map(&:valid?).all?
      imported_students.each(&:save!)
      true
    else
      if errors.empty?
        imported_students.each_with_index do |student, index|
          student.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+2}: #{message}</br>"
            return false if index > 5 #This is to make sure we don't run out of memory
          end
        end
      end
      false
    end
  end

  def imported_students
    @imported_students ||= load_imported_students
  end

  def load_imported_students
    spreadsheet = open_spreadsheet
    return load_error "Please select the file after filling in the details" if spreadsheet.nil?    
    return load_error " You can't upload more than 2000 entries at a time" if spreadsheet.last_row > 2000
    return load_error "No students added in the sheet, Please add atleast one entry" if spreadsheet.last_row < 2
    
    header_compare = [
      "first_name","last_name","aadhar_number","phone","email","date_of_birth","gender","mother_tounge","religion","caste","disability","address","ward_type",
      "admission_number","admission_date","admission_class",
      "branch", "medium","class","section","roll_number","fees_payed",
      "father_name","father_phone","father_email","father_qualification","father_occupation","father_income",
      "mother_name","mother_phone","mother_email","mother_qualification","mother_occupation","mother_income",
      "gaurdian_name","gaurdian_phone","gaurdian_email","gaurdian_qualification","gaurdian_occupation","gaurdian_income"
    ]
    begin
      header = underscore spreadsheet.row(1)
      unequal_arrays = (header_compare-header).any? || (header-header_compare).any?
      return load_error "First row of the sheet needs to have all the columns listed below #{(header_compare-header).join(",")} -- #{(header-header_compare).join(",")}" if unequal_arrays

      rescue NoMethodError
        return load_error 'First row of the sheet needs to have all the columns listed below'
    end

    (2..spreadsheet.last_row).map do |i|
      if(spreadsheet.row(i).compact.size < 3)
        return load_error "Row " + i.to_s + " has inadequate data, Make sure there are no blank rows in between and also make sure that they have valid Name/Date Of Birth and Gender entered"
      end
      row = Hash[[header, spreadsheet.row(i)].transpose]
      student = Student.find_by_row(row)
      if student.nil?
        student = Student.new
        student.first_name = row["first_name"]
        student.date_of_birth = row["date_of_birth"].to_date
        student.gender = set_gender(row["gender"])
      end
        
      student.last_name = row["last_name"]
      student.aadhar_number = row["aadhar_number"]        
      student.phone = row["phone"]
      student.email = row["email"]

      student.mother_tounge = row["mother_tounge"]
      student.religion = row["religion"]
      student.caste = row["caste"]
      student.disability = row["disability"]
      student.address = row["address"]
      student.ward_type = row["ward_type"]

      student.admission_number = row["admission_number"]
      student.joined_class = row["admission_class"]
      student.joined_on = row["admission_date"]

      student_year_attrs = {
        academic_year: StudentYear.current_year, 
        branch: row["branch"], 
        medium: row["medium"], 
        classroom: row["class"], 
        section: row["section"], 
        roll_number: row["roll_number"]
      }
      student_year_attrs[:fees_payed] = (row["fees_payed"] == "Yes") if row["fees_payed"]

      if (current_student_year = student.current_student_year).blank?
        student.student_years.build(student_year_attrs)
      else
        current_student_year.update_attributes!(student_year_attrs)
      end

      if row["father_name"] || row["mother_name"] || row["gaurdian_name"]
        @parent_attrs = []

        if row["father_name"]
          father_attrs = {
            name: row["father_name"],
            email: row["father_email"],
            phone: row["father_phone"],
            qualification: row["father_qualification"],
            occupation: row["father_occupation"],
            income: row["father_income"],
            relation: Parent::RelationShip::FATHER
          }
          update_parent_if_present(student.father, father_attrs)
        end

        if row["mother_name"]
          mother_attrs = {
            name: row["mother_name"],
            email: row["mother_email"],
            phone: row["mother_phone"],
            qualification: row["mother_qualification"],
            occupation: row["mother_occupation"],
            income: row["mother_income"],
            relation: Parent::RelationShip::MOTHER
          }
          update_parent_if_present(student.mother, mother_attrs)
        end
        

        if row["gaurdian_name"]
          gaurdian_attrs = {
            name: row["gaurdian_name"],
            email: row["gaurdian_email"],
            phone: row["gaurdian_phone"],
            qualification: row["gaurdian_qualification"],
            occupation: row["gaurdian_occupation"],
            income: row["gaurdian_income"],
            relation: Parent::RelationShip::GAURDIAN
          } 
          update_parent_if_present(student.gaurdian, gaurdian_attrs)
        end

        student.parents.build(@parent_attrs) if @parent_attrs.any?
      end
      student
    end
  end

  def load_error error_message
      errors.add :base, error_message
      user = Student.new
      return [user]
  end

  def underscore header
    header.map do |val|
      val.strip.gsub(/\s+/, "_").
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      downcase
    end
  end

  def set_gender(value)
    if ["female","girl"].include?(value)
      "Female"
    elsif ["boy","male"].include?(value)
      "Male"
    else
      value
    end
  end

  def update_parent_if_present(parent, attrs)
    return if attrs.blank?
    
    if parent.present?
      parent.update_attributes!(attrs)
    else
      @parent_attrs << attrs
    end
  end

  def open_spreadsheet
    if file.nil?
      return
    end
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
   end
 end

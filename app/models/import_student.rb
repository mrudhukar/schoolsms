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
          errors.add :base, "Row #{index+2}: #{message}"
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
      return load_error 'First row of the sheet needs to have all the columns listed below' if header != header_compare

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
        student.last_name = row["last_name"]
        student.aadhar_number = row["aadhar_number"]        
        student.phone = row["phone"]
        student.email = row["email"]

        student.date_of_birth = row["date_of_birth"].to_date if row["date_of_birth"]
        student.gender = row["gender"]
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

        student.student_years.build(student_year_attrs)

        if rows["father_name"] || rows["mother_name"] || rows["gaurdian_name"]
          parent_attrs = []
          parent_attrs << {
            name: rows["father_name"],
            email: rows["father_email"],
            phone: rows["father_phone"],
            qualification: rows["father_qualification"],
            occupation: rows["father_occupation"],
            income: rows["father_income"],
            relation: Parent::RelationShip::FATHER
          } if rows["father_name"]

          parent_attrs << {
            name: rows["mother_name"],
            email: rows["mother_email"],
            phone: rows["mother_phone"],
            qualification: rows["mother_qualification"],
            occupation: rows["mother_occupation"],
            income: rows["mother_income"],
            relation: Parent::RelationShip::MOTHER
          } if rows["mother_name"]

          parent_attrs << {
            name: rows["gaurdian_name"],
            email: rows["gaurdian_email"],
            phone: rows["gaurdian_phone"],
            qualification: rows["gaurdian_qualification"],
            occupation: rows["gaurdian_occupation"],
            income: rows["gaurdian_income"],
            relation: Parent::RelationShip::GAURDIAN
          } if rows["gaurdian_name"]
        end
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
      val.gsub(/\s+/, "").gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end

  def open_spreadsheet
    if file.nil?
      return
    end
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
   end
 end

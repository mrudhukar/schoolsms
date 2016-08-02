class AddDataToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :aadhar_number, :string
    add_column :students, :admission_number, :string
    add_column :students, :religion, :string
    add_column :students, :ward_type, :string
    
    add_column :students, :mother_tounge, :string
    add_column :students, :disability, :string


    add_column :students, :city, :string
    add_column :students, :state, :string
    add_column :students, :country, :string
    add_column :students, :address, :text

    add_column :students, :joined_class, :text

    # For student passing out
    add_column :students, :conduct, :text
    add_column :students, :remarks, :text
    add_column :students, :qualified_class, :string
    add_column :students, :tc_apply_date, :date
    add_column :students, :relieving_date, :date

    add_column :student_years, :roll_number, :string
    add_column :student_years, :fees_payed, :boolean

    add_column :parents, :qualification, :string
    add_column :parents, :income, :string
  end
end

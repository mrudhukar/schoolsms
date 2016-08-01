module StudentsHelper
  def parent_logo(parent)
    if parent.relation == "Father"
      image_tag("father.jpg", class: "img-circle m-t-xs img-responsive", width: 80)
    elsif parent.relation == "Mother"
      image_tag("mother.jpg", class: "img-circle m-t-xs img-responsive", width: 80)
    else
      image_tag("guardian.svg", class: "img-circle m-t-xs img-responsive", width: 80)
    end
  end

  def student_logo(student)
    if student.gender == "Female"
      image_tag("student_girl_icon.jpg", class: "img-circle circle-border m-b-md")
    else
      image_tag("student_boy_icon.jpg", class: "img-circle circle-border m-b-md")
    end
  end
end

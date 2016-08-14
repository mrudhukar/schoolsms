module AttendancesHelper
  def display_attendance(student_atts, day, syid)
    if student_atts.blank?
      display_present(day, syid)
    else
      att = student_atts.select{|sa| sa.absent_on == day}[0]
      if att.present?
        if att.absent_type == Attendance::AbsentType::FULLDAY
          full_drop_down_button("Absent", "btn-danger", [mark_present(day, syid), mark_morning_absent(day, syid), mark_evening_absent(day, syid)])
        elsif att.absent_type == Attendance::AbsentType::MORNING
          full_drop_down_button("Absent in morning", "btn-warning", [mark_present(day, syid), mark_full_absent(day, syid), mark_evening_absent(day, syid)])
        elsif att.absent_type == Attendance::AbsentType::EVENING
          full_drop_down_button("Absent in evening", "btn-warning", [mark_present(day, syid), mark_full_absent(day, syid), mark_morning_absent(day, syid)])
        end
      else
        display_present(day, syid)
      end
    end
  end

  def display_present(day, syid)
    full_drop_down_button("Present", "btn-white", [mark_full_absent(day, syid), mark_morning_absent(day, syid), mark_evening_absent(day, syid)])
  end

  def mark_present(day, syid)
    link_to("Mark Present", attendances_path(syid: syid, day: day, present: true), method: :post)
  end

  def mark_full_absent(day, syid)
    link_to("Mark Fullday Absent", attendances_path(syid: syid, day: day, abtype: Attendance::AbsentType::FULLDAY), method: :post)
  end

  def mark_morning_absent(day, syid)
    link_to("Mark Morning Absent", attendances_path(syid: syid, day: day, abtype: Attendance::AbsentType::MORNING), method: :post)
  end

  def mark_evening_absent(day, syid)
    link_to("Mark Evening Absent", attendances_path(syid: syid, day: day, abtype: Attendance::AbsentType::EVENING), method: :post)
  end
end
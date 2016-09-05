module MessageTemplates
  ALL = {
    message_to_absentees: {
      type: 0,
      name: "Message to absentees",
      value: Proc.new{|firstname_20| "Dear parent, your child #{firstname_20} was absent today without prior information. Kindly send duly signed leave letter with your child. - Sarada School"},
      example: {firstname: "Ravi"}
    },

    festival_wishes: {
      type: 1,
      name: "Festival wishes",
      value: Proc.new{|festivalname_20| "Wish you very happy #{festivalname_20}. -Sarada School"},
      example: {festivalname: "Diwali"}
    },

    announce_holiday_and_wish: {
      type: 1,
      name: "Announce festival holiday and send wishes",
      value: Proc.new{|date_10, festivalname_20| "Dear parent, #{date_10} will be holiday on occasion of #{festivalname_20}. Wish you happy #{festivalname_20}. -Sarada School"},
      example: {date: "Jan 1st", festivalname: "New year"}
    },

    announce_holiday_without_wishes: {
      type: 1,
      name: "Announce holiday (wishes are not sent)",
      value: Proc.new{|date_10, festivalname_20| "Dear parent, #{date_10} will be holiday on occasion of #{festivalname_20}. - Sarada School"},
      example: {date: "Oct 2nd", festivalname: "Gandhi Jayanthi"}
    },

    unexpected_holiday: {
      type: 1,
      name: "Unexpected holiday or Bandh notification",
      value: Proc.new{|date_10, event_20|"Dear parent, school remains closed on #{date_10} due to #{event_20}. - Sarada school."},
      example: {date: "Oct 31st", event: "SFI Bandh"}
    },

    vacation: {
      type: 1,
      name: "Vacation announcement",
      value: Proc.new{|vacation_15, startdate_10, enddate_10, reopendate_10| "Dear parent, #{vacation_15} vacation starts from #{startdate_10} to #{enddate_10}.School reopens on #{reopendate_10}. -Sarada School."},
      example: {vacation: "Dussehra", startdate: "Oct 5th", enddate: "Oct 15th", reopendate: "Oct 17th"}
    },

    reopen: {
      type: 1,
      name: "School reopen reminder",
      value: Proc.new{|vacation_15, reopendate_10| "Dear parent, school reopens on #{reopendate_10} after #{vacation_15} vacation. Attendance on the first day is mandatory. - Sarada School."},
      example: {vacation: "Dussehra", reopendate: "Oct 17th"}
    },

    new_competition: {
      type: 1,
      name: "Competition announcement",
      value: Proc.new{|name_20, datetime_10, location_20| "Dear parent, #{name_20} competition will be held on #{datetime_10} at #{location_20} premises."},
      example: {name: "Quiz", datetime: "Feb 17th 11AM", location: "School"}
    },

    new_event: {
      type: 1,
      name: "Event announcement",
      value: Proc.new{|name_20, datetime_10, location_20, starttime_10, endtime_10| "Dear parent, #{name_20} will be held on #{datetime_10} at #{location_20} premises from #{starttime_10} to #{endtime_10}. - Sarada School."},
      example: {name: "Annualday", datetime: "Feb 17th", location: "School", starttime: "6PM", endtime: "9PM"}
    },

    parent_teacher_meeting: {
      type: 1,
      name: "Parent Teacher Meeting Invite",
      value: Proc.new{|date_10, starttime_10, endtime_10| "Dear parent, Kindly attend the parent-teacher meeting scheduled on #{date_10} from #{starttime_10} to #{endtime_10}. - Sarada School."},
      example: {date: "Feb 14th", starttime: "10:30AM", endtime: "11:30AM"}
    },

    dress_code: {
      type: 1,
      name: "Dress code request",
      value: Proc.new{|ocassion_15, date_10, dress_15| "Dear parent, on the ocassion of #{ocassion_15} day on #{date_10}, your child is requested to wear #{dress_15}. - Sarada School."},
      example: {ocassion: "Sports", date: "Mar 1st", dress: "white dress"}
    },

    fees: {
      type: 1,
      name: "Fees Reminder",
      value: Proc.new{|term_15, duedate_10, lastdate_10| "Dear parent, #{term_15} fee is due on #{duedate_10}. Kindly pay before #{lastdate_10}. Please ignore if already paid - Sarada School."},
      example: {term: "Mid term", duedate: "Nov 30th", lastdate: "Dec 15th"}
    },

    timetable: {
      type: 1,
      name: "Test Timetable",
      value: Proc.new{|test_15| "Dear parent, time table for #{test_15} has been announced."},
      example: {test: "quarterly test"}
    },

    timetable_v2: {
      type: 1,
      name: "Test Timetable with details",
      value: Proc.new{|test_15, data_96| "Dear parent, time table for #{test_15} is #{data_96} - Sarada School."},
      example: {test: "quarterly test", data: "English,Telugu,Hindi,Social,Science,Maths on Jan1st,2nd,3rd,4th,Feb7th,15th"}
    },

    results: {
      type: 2,
      name: "Results of student",
      value: Proc.new{|test_15, firstname_20, data_80| "Dear parent, #{test_15} results of #{firstname_20} is #{data_80} -Sarada School."},
      example: {test: "quarterly test", firstname: "Ravi", data: "English-75,Telugu-80,Hindi-75,Social-65,Science-90,Maths-100"}
    }
  }
end
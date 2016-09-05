module MessagesHelper
  def show_status(message)
    return "-" if message.blank?

    if message.status == Message::Status::SUCCESS
      "Successful"
    elsif message.status == Message::Status::FAILURE
      "Failure"
    elsif message.status == Message::Status::PENDING
      "Pending Delivery"
    end
  end

  def show_status_label(message)
    if message.status == Message::Status::SUCCESS
      content_tag(:span, "Successful", class: "label label-primary")
    elsif message.status == Message::Status::FAILURE
      content_tag(:span, "Failure", class: "label label-danger")
    elsif message.status == Message::Status::PENDING
      content_tag(:span, "Pending Delivery", class: "label label-warning")
    end
  end

  def show_message_criteria(message)
    message.criteria_hash.
    reject{|k,v| ["with_number","with_academic_year"].include?(k) }.
    collect{|k,v| "#{cleanup_keys(k)}: #{v}" }.
    join(", ")
  end

  def show_message_response(message)
    return "-" if message.status == Message::Status::PENDING

    message.response_hash.collect{|k,v| "#{k}: #{v}"}.join(", ")
  end

  def recepient_collection
    [
      ["Only Mothers", Parent::RelationShip::MOTHER],
      ["Only Fathers", Parent::RelationShip::FATHER]
    ]
  end

  def template_collection
    MessageTemplates::ALL.select{|key, value| value[:type] != 2 }.collect{|key, value| [value[:name], key.to_s]}
  end

  def message_templates
    hash = {}
    MessageTemplates::ALL.each_pair do |key, val|
      next if val[:type] == 2 
      attrs = val[:value].parameters.collect{|v| v[1].to_s}
      inputs = attrs.collect do |c|
        ekey, length = get_name_length(c)
        text_field_tag("values[]",nil, size: length.to_i+5, maxlength: length, placeholder: "E.g. #{val[:example][ekey.to_sym]}")
      end
      hash[key] = {content: raw(val[:value].call(inputs.size > 1 ? inputs : inputs[0])), type: val[:type]}
    end

    hash
  end

  private

  def cleanup_keys(string)
    string.to_s.gsub('with_','').gsub('klass','class').capitalize
  end

  def get_name_length(attribute)
    attribute.split("_")
  end

end

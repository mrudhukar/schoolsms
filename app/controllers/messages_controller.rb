class MessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:update_status]

  def new
    @tab = TabConstants::DASHBOARD
    @message = Message.new()

    set_parameters(params[:filterrific])
    @parents_count = @filterrific.find.count

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
    set_parameters(params[:filters])
    parent_numbers = @filterrific.find.pluck(:phone)
    @message = Message.new(message_params)
    @message.criteria = Base64.encode64(Marshal.dump(@all_filters.to_hash))
    @message.send_to = parent_numbers.size

    if @message.save
      if @message.send_sms(parent_numbers)
        redirect_to root_path, notice: 'The message has been sent out to #{parent_numbers.size} parents'
      else
        redirect_to root_path, alert: "The message has failed. #{@message.error_message}"
      end
    else
      render :new, alert: "Please fix the errorr below"
    end
  end

  def index
    @messages = Message.page(params[:page]).per_page(25)
  end

  def update_status
    message = Message.find(params[:customID])
    response_hash = message.response_hash.merge("#{params[:number]}": {status: params[:status], date_time: params[:date_time]})
    message.response = Base64.encode64(Marshal.dump(response_hash))
    message.save!
  end

  private

  def set_parameters(f_params)
    @all_filters = (f_params || {}).merge({with_academic_year: StudentYear.current_year, with_number: true})
    @filterrific = initialize_filterrific(
      Parent,
      @all_filters,
    ) or return
  end

  def message_params
    params.require(:message).permit(:content)
  end
end

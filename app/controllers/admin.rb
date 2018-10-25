Leverans::App.controllers :admin do

  get :index do
    sheet = Leverans::Sheet.new(settings.google_sheet)
    weeks = sheet.weeks
    render 'admin/index', locals: { weeks: weeks }
  end

  get :sms do
    sheet = Leverans::Sheet.new(settings.google_sheet)
    render 'admin/sms', locals: { users: sheet.users, sms: [], validation: {} }
  end

  post :sms do
    recipients = {}
    send_status=[]
    validation_errors={}
    sheet = Leverans::Sheet.new(settings.google_sheet)

    validation_errors["recipients"] = "Mottagare saknas" if params[:recipients].nil?
    validation_errors["sure"] = "Vill du inte skicka?" if !params[:sure]
    validation_errors["message"] = "Meddelande saknas" if params[:message].empty?
    if validation_errors.empty?
      params[:recipients].each do |r|
        type, target = r.split(',')
        if type == 'pickup'
          sheet.users.pickup(target).each do |user|
            if user.phone.blank?
              send_status<<[:error, user.name, user.email, user.phone, "Saknar telefonnummer."]
            else
              recipients[user.phone] = user
            end
          end
        elsif type == 'weekday'
          sheet.users.weekday(target).each do |user|
            if user.phone.blank?
              send_status<<[:error, user.name, user.email, user.phone, "Saknar telefonnummer."]
            else
              recipients[user.phone] = user
            end
          end
        end
      end
      @client = Twilio::REST::Client.new settings.twilio_sid, settings.twilio_secret
      recipients.each do |phone, user|
        begin
          @message = @client.messages.create(
            to: format_phone(user.phone),
            from: settings.twilio_phone,
            body: params[:message]
          )
          send_status<<SmsStatus.new(:success, user, message: 'Skickat!')
          logger.info "Sent SMS to #{user.name} #{user.phone} #{params[:message]}"
        rescue => e
          send_status<<SmsStatus.new(:error, user, message: e.message, css_class: 'danger')
          logger.fatal "Failed to send to #{user.name} #{user.phone}: #{e.message}"
        end
      end
    end
    render 'admin/sms', locals: { users: sheet.users, sms: send_status, validation: validation_errors }
  end

  get :etiketter, map: "/admin/etiketter_v:week.pdf" do
    week = params[:week]
    sheet = Leverans::Sheet.new(settings.google_sheet)
    unless sheet.users.weeks.include?(week)
      content_type :text
      response.write('Denna veckan finns inte!')
    else
      users = sheet.users.week(week)
      pdf = Leverans::Pdf::Labels.new(users, week)
      content_type :pdf
      #attachment("etiketter_v#{week}.pdf")
      response.write(pdf.render)
    end
  end

  get :packlista, map: "/admin/packlista_v:week.pdf" do
    week = params[:week]
    sheet = Leverans::Sheet.new(settings.google_sheet)
    unless sheet.users.weeks.include?(week)
      content_type :text
      response.write('Denna veckan finns inte!')
    else
      users = sheet.users.week(week)
      pdf = Leverans::Pdf::PackingList.new(users, week)
      content_type :pdf
      #attachment("packlista_v#{week}.pdf")
      response.write(pdf.render)
    end
  end
end

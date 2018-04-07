Leverans::App.controllers :schedule do
  def self.protect(protected)
    condition do
      redirect '/' unless authorized?
    end if protected
  end

  get :index, protect: true do
    sheet = Leverans::Sheet.new(settings.google_sheet)
    user = sheet.users.user_by_email(session[:current_user])
    weeks = sheet.weeks
    weeks_schedule = weeks.zip(user.schedule).to_h
    render 'schedule/index', locals: { user: user, weeks: weeks, weeks_schedule: weeks_schedule }
  end

  post :save, protect: true do
    sheet = Leverans::Sheet.new(settings.google_sheet)
    user = sheet.users.user_by_email(session[:current_user])
    new_schedule = Array.new(sheet.weeks.size)
    params['schedule'].each do |key, value|
      if value == 'true' || value == 'on'
        new_schedule[key.to_i] = true
      else
        new_schedule[key.to_i] = false
      end
    end
    user.schedule=new_schedule
    user.save
    flash[:success] = 'Dina ändringar har sparats!'
    Padrino.logger.info new_schedule
    redirect 'schedule'
  end
end

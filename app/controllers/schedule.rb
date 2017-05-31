Leverans::App.controllers :schedule do
  def self.protect(protected)
    condition do
      redirect '/' unless authorized?
    end if protected
  end

  get :index, protect: true do
    sheet = Leverans::Sheet.new(settings.google_sheet)
    user = sheet.user(session[:current_user])
    weeks = sheet.weeks
    render 'schedule/index', locals: { user: user, weeks: weeks }
  end

  post :save, protect: true do
    sheet = Leverans::Sheet.new(settings.google_sheet)
    user = sheet.user(session[:current_user])
    schedule = Array.new(sheet.weeks.size, false)
    params['schedule'].each do |key, _|
      schedule[key.to_i] = true
    end
    user.schedule = schedule
    user.save
    flash[:success] = 'Dina ändringar har sparats!'
    Padrino.logger.info schedule
    redirect 'schedule'
  end
end

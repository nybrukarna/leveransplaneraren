Leverans::App.controllers :session do
  post :create, protect: false do
    if params[:email].empty?
      flash[:alert] = 'Du måste fylla i din e-post.'
      redirect '/session/new'
    end
    sheet = Leverans::Sheet.new(settings.google_sheet)
    user = sheet.users.select { |u| u.email.downcase == params[:email].downcase }.first
    unless user.nil?
      session[:current_user] = user.email
      session[:user] = user.to_h
    else
      flash[:alert] = "Vi kunde inte hitta din användare (#{params[:email]})! Hör av dig till oss så hjälper vi dig!"
      redirect '/session/new'
    end
    redirect '/schedule'
  end

  get :destroy do
    session[:current_user] = nil
    session[:user] = nil
    redirect '/'
  end

  get :new do
    render 'session/new'
  end
end

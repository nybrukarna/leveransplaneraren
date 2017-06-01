Leverans::App.controllers :session do
  post :create, protect: false do
    sheet = Leverans::Sheet.new(settings.google_sheet)
    user = sheet.users.select { |u| u.email.downcase == params[:email].downcase }.first
    unless user.nil?
      session[:current_user] = user.email
      session[:user] = user.to_h
    end
    redirect '/'
  end

  get :destroy do
    session[:current_user] = nil
    session[:user] = nil
    redirect '/'
  end
end

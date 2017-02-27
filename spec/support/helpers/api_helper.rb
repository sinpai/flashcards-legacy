module ApiHelper
  def basic_auth(user, password)
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials user, password
    request.env['HTTP_AUTHORIZATION'] = credentials
  end

  def auth(user, password)
    request.env['Authorization'] = ActionController::HttpAuthentication::Basic.encode_credentials user, password
  end
end

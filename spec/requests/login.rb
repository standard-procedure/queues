module Login
  def login_as user, password: "password123"
    post session_path, params: {email_address: user.email_address, password: password}
    follow_redirect!
  end
end

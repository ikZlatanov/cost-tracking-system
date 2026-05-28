module SessionHelper
  USER_PASSWORDS = {
    admin: "iZlatanov123",
    project_manager: "bond123James",
    developer: "michaelJ123"
  }.freeze

  def login_as(user_fixture)
    user = users(user_fixture)

    post login_path, params: {
      email: user.email,
      password: USER_PASSWORDS.fetch(user_fixture)
    }
  end
end
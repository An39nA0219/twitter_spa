class ApplicationController < ActionController::API
  def current_user
    token = request.headers['Authorization']
    if token.present?
      if token.include?(" ")
        token = token.split(" ")[1]
        if token.present?
          if token.split(".").size == 3
            secret = ENV['JWT_PW']
            decoded = JWT.decode(token, secret, true, algorithm: 'HS512')
            user_id = decoded[0]['user_id']
            limit = decoded[0]['limit']
            now = DateTime.now.to_i

            if now < limit
              current_user ||= User.find_by(id: user_id)
            end
          end
        end
      end
    end
  end

  def require_user_logged_in
    unless !!current_user
      render_unauthorized
    end
  end
end

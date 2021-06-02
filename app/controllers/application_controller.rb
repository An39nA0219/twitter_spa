class ApplicationController < ActionController::API

  def current_user
    token = request.headers['Authorization']
    if token.present?
      if token.include?(" ")
        token = token.split(" ")[1]
        if token.present?
          if token.split(".").size == 3
            secret = Rails.application.credentials[:jwt_pw]
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

  # HTTPステータスコード

  # 400 Bad Request
  def render_bad_request(msg)
    render status: 400, json: { status: 400, msg: msg }
  end

  # 401 Unauthorized
  def render_unauthorized
    render status: 401, json: { status: 401, msg: 'Unauthorized' }
  end

  # 404 Not Found
  def render_not_found(class_name = 'page')
    render status: 404, json: { status: 404, msg: "#{class_name.capitalize} Not Found" }
  end

  # 409 Conflict
  def render_conflict(class_name)
    render status: 409, json: { status: 409, msg: "#{class_name.capitalize} Conflict" }
  end

  # 500 Internal Server Error
  def render_internal_server_error(msg)
    render status: 500, json: { status: 500, msg: msg }
  end

end

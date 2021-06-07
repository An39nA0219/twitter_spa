class ApplicationController < ActionController::API
  require 'openssl'
  require 'base64'

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

  # AES暗号化(メール)
  def aes_encrypt_for_email(text)
      
    # salt
    salt = Rails.application.credentials[:aes_salt_for_email]

    # password
    password = Rails.application.credentials[:aes_pw_for_email]

    # 暗号器を生成
    enc = OpenSSL::Cipher::AES.new(256, :CBC)
    enc.encrypt

    # パスワードとsaltをもとに鍵とivを生成し、設定
    key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 2000, enc.key_len + enc.iv_len, "sha256")
    enc.key = key_iv[0, enc.key_len]
    enc.iv = key_iv[enc.key_len, enc.iv_len]

    # 文字列を暗号化
    encrypted_text = enc.update(text) + enc.final

    # Base64でエンコード
    encrypted_text = Base64.encode64(encrypted_text).chomp
    salt = Base64.encode64(salt).chomp

    return encrypted_text
  end

  # AES復号化(メール)
  def aes_decrypt_for_email(text) 

    # Base64でデコード
    encrypted_text = Base64.decode64(text)

    # salt
    salt = Rails.application.credentials[:aes_salt_for_email]

    # password
    password = Rails.application.credentials[:aes_pw_for_email]
  
    # 復号器を生成
    dec = OpenSSL::Cipher::AES.new(256, :CBC)
    dec.decrypt
  
    # パスワードとsaltをもとに鍵とivを生成し、設定
    key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 2000, dec.key_len + dec.iv_len, "sha256")
    dec.key = key_iv[0, dec.key_len]
    dec.iv = key_iv[dec.key_len, dec.iv_len]
  
    # 暗号を復号
    return dec.update(encrypted_text) + dec.final
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

class AuthServiceClient
  class << self
    def base_url
      Rails.application.config.auth_service_url
    end

    def sign_in(email, password)
      response = HTTParty.post(
        "#{base_url}/users/sign_in",
        headers: { 
          "Content-Type" => "application/json",
          "X-Requested-With" => "XMLHttpRequest"
        },
        body: { user: { email: email, password: password } }.to_json,
        timeout: 10
      )
      parse_response(response)
    end

    def sign_up(email, password, password_confirmation)
      response = HTTParty.post(
        "#{base_url}/users",
        headers: { 
          "Content-Type" => "application/json",
          "X-Requested-With" => "XMLHttpRequest"
        },
        body: { user: { email: email, password: password, password_confirmation: password_confirmation } }.to_json,
        timeout: 10
      )
      parse_response(response)
    end

    def sign_out(token)
      response = HTTParty.delete(
        "#{base_url}/users/sign_out",
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{token}",
          "X-Requested-With" => "XMLHttpRequest"
        },
        timeout: 10
      )
      parse_response(response)
    end

    def fetch_public_key
      response = HTTParty.get(
        "#{base_url}/api/v1/public_keys/show",
        headers: { 
          "Content-Type" => "application/json",
          "X-Requested-With" => "XMLHttpRequest"
        },
        timeout: 10
      )
      parsed = parse_response(response)
      parsed[:body]["public_key"] if parsed[:success]
    end

    def public_key
      @public_key ||= fetch_public_key
    end

    def reset_public_key!
      @public_key = nil
    end

    def verify_token(token)
      pem = public_key
      return nil unless pem

      rsa_key = OpenSSL::PKey::RSA.new(pem)
      decoded = JWT.decode(token, rsa_key, true, algorithm: "RS256")
      decoded.first
    rescue JWT::ExpiredSignature, JWT::DecodeError, JWT::VerificationError => e
      Rails.logger.warn("JWT verification failed: #{e.message}")
      nil
    end

    private

    def parse_response(response)
      body = JSON.parse(response.body)
      { success: response.success?, status: response.code, body: body }
    rescue JSON::ParserError
      { success: false, status: response.code, body: { "message" => "Invalid response from auth service" } }
    end
  end
end

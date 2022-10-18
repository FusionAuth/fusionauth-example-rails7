require 'uri'  
require 'net/http'  


class TokenDecoder

  JWKS_URL = "#{Rails.configuration.x.oauth.idp_url}/.well-known/jwks.json".freeze

  def initialize(token, aud)
    @token = token
    @aud = aud
    @iss = Rails.configuration.x.oauth.idp_url
  end

  def decode
    begin
      jwt = JWT.decode(@token, nil, true,
      { 
        verify_iss: true,
        iss: @iss,
        verify_aud: true,
        aud: @aud,
        algorithm: 'RS256',
        jwks: fetch_jwks
      })

      claims = jwt[0]
      if claims["applicationId"] != @aud
        # user is not registered
        Rails.logger.warn("User not registered")
        raise NotRegisteredError 
      end
      return jwt
    rescue JWT::VerificationError
      Rails.logger.warn("Verification error")
      raise
    rescue JWT::DecodeError
      Rails.logger.warn("Decode failed")
      raise
    end
  end

  def fetch_jwks
    response = Net::HTTP.get_response(URI(JWKS_URL))  
    if response.code.to_i == 200.to_i
      puts "returning"
      return JSON.parse(response.body.to_s)
    end
  end
end

class NotRegisteredError < StandardError
  def initialize(msg="User isn't registered")
    super
  end
end



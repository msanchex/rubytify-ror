module Spotify

  require 'rest-client'
  require 'json'

  # This class handles the auth token lifecycle making sure that
  # a valid token isalways used for communicating with the spotify
  # application using client_credentials OAuht2 flow
  class AccessToken

    # This is used to issue a new token whenever the token is about to expire,
    # to make sure that a valid token is available before making any request.
    TOKEN_EXPIRATION_THRESHOLD = 10

    # URL to generate a new access token.
    CLIENT_URL = 'https://accounts.spotify.com/api/token'

    # Initialize an access token object
    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
      @token = ''
      @expires_at = 0
    end

    # Get the current access token.
    def token
      generate
      return @token
    end

    protected

    # Generate a new access token if it is not generated yet
    # or the existing one has expired.
    def generate
      if expired?
        token_response = RestClient::Request.execute(
          method: :post,
          url: CLIENT_URL,
          user: @client_id,
          password: @client_secret,
          payload: {grant_type: 'client_credentials'}
        )

        token_response = JSON.parse(token_response.to_str)
        @token = token_response['access_token']
        @expires_at = Time.now.to_i + token_response['expires_in'] - TOKEN_EXPIRATION_THRESHOLD
      end
    end

    # Returns true if the token has expired or is about to expire.
    def expired?
      return Time.now.to_i >= @expires_at
    end

  end
end

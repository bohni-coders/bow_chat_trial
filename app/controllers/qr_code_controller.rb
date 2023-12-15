require 'httparty'

class QrCodeController < ApplicationController
  include HTTParty
  include RequestExceptionHandler

  def get_hash_code
    url = ENV['SOCKET_URL']

    puts url

    options = {
      timeout: 20,
      open_timeout: 20,
      data: params,
    }

    begin
      response = self.class.get(url, options)

      if response.success?
        render json: { data: response.body, code: response.code }
      else
        render json: { data: nil, code: response.code, error: response.message }
      end
    rescue Net::ReadTimeout => e
      render json: { data: nil, code: 504, error: 'Gateway Timeout' }
    rescue SocketError => e
      render json: { data: nil, code: 500, error: 'Internal Server Error' }
    rescue => e
      render json: { data: nil, code: 500, error: e.message }
    end
  end
end

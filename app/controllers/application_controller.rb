class ApplicationController < ActionController::API

  def proxy
    render json: proxy_response.body, status: proxy_response.code
  end

  private

  def proxy_response
    @proxy_response ||= Proxy.proxy_request request
  end
end

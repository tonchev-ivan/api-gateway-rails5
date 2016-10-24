require 'httparty'

module Proxy
  class << self
    def proxy_request(request)
     begin
        response = HTTParty.send(request.method.downcase.to_sym,
          "http://localhost:3000" + request.path,
          query: request.params.except(:controller, :action, :application, :path),
          body: request.body.read.to_s,
          headers: get_headers(request))

        unless valid_json?(response.body)
          puts "Reponse was not in json format"
          raise StandardError.new("Invalid request")
        end

        ResponseObject.new(response.body, response.code)
      rescue StandardError => e
        puts e.message
        puts e.backtrace
        ResponseObject.new({error: e.message}.to_json, 500)
      end
    end

    private

    def get_headers(request)
      Hash[*request.headers.to_h.select{|k,v| k.start_with?('HTTP_') || (k == 'CONTENT_TYPE') }
      .collect {|k,v| [k.sub(/^HTTP_/, ''), v]}
      .collect {|k,v| [k.split('_').collect(&:capitalize).join('-'), v]}
      .sort
      .flatten].except('Host', 'Connection', 'Version', 'X-Forwarded-For', 'X-Forwarded-Port', 'X-Forwarded-Proto')
    end

    def valid_json?(json)
      begin
        JSON.parse(json)
      rescue JSON::ParserError => e
        false
      end
    end
  end
end

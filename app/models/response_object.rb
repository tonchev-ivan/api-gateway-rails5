class ResponseObject
  attr_accessor :body, :code

  def initialize(body, code)
    @body = body
    @code = code
  end
end

class AzureEnventHubService
  # The implementation in this class is based on
  # https://msdn.microsoft.com/en-us/library/azure/dn790664.aspx
  def initialize
    @conn = Faraday.new(:url => AZURE_URL)
  end

  def send_event(telemetry)
    #Rails.logger.debug "Azure URL  = #{AZURE_URL}"
    #Rails.logger.debug "telemetry  = #{telemetry}"
    #Rails.logger.debug " telemetry length #{telemetry}".length

    url = "/#{EVENT_HUB_NAME}/publishers/#{PUBLISHER_NAME}/messages"
    response = @conn.post url do |request|
      request.options.timeout = 60
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = EVENT_HUB_SIGNATURE
      # request.headers['Content-Length'] = "#{telemetry}".length
      request.body = "#{telemetry}"  #json_payload
    end

    Rails.logger.debug "response status = #{response.status}"
    Rails.logger.debug "response body = #{response.body}"

    #response body is always null if successful so check for status code only.
    response.status == 201 #&& ((response.body).include? 'Created')

  rescue Faraday::Error::ConnectionFailed
    raise ConnectionFailed, "\n Unable to establish connection to #{AZURE_URL}"
  rescue Faraday::Error::TimeoutError
    raise Timedout, "\n Connection to #{AZURE_URL} timed out"

  end
end

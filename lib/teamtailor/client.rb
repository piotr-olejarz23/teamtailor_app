module Teamtailor
  class RequestFailed < StandardError; end

  class Client
    include Singleton

    def fetch_candidates_with_jobs(params)
      request(:get, "v1/candidates?include=job-applications", params)
    end

    private

    def request(method, path, params = {})
      response = connection.send(method, path, params).tap do |resp|
        raise Teamtailor::RequestFailed, "response: { status: #{resp.status}, body: #{resp.body} }, request: { path: #{path} }" unless success?(resp)
      end

      JSON.parse(response.body)
    end

    def connection
      Faraday.new(options)
    end

    def options
      {
        url: teamtailor_credentials(:host),
        headers: headers
      }
    end

    def headers
      {
        "Content-Type" => "application/json",
        "Authorization" => teamtailor_credentials(:api_key),
        "X-Api-Version" => teamtailor_credentials(:api_version)
      }
    end

    def success?(resp)
      [ 200, 201 ].include?(resp.status)
    end

    def teamtailor_credentials(name)
      Rails.application.credentials.teamtailor.fetch(name)
    end
  end
end

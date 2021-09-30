class GitHubService
  include ResponseHelper
  API_URL = 'https://api.github.com/users/??/repos'

  attr_accessor :username

  def initialize(username)
    @username = username
  end

  def call
    return empty_response if username.blank?

    response = get_repos
    { '200' => format_response(response.body),
      '404' => not_found_response }.fetch(response.code, failure_response(response))
  rescue StandardError => e
    Rails.logger.error { e.backtrace.first(25).join("\n") }
    error_response(e)
  end

  private

  def get_repos
    uri = URI(API_URL.gsub('??', username))
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      http.request request
    end
  end

  def format_response(response_body)
    payload = JSON.parse(response_body)
    [filter_public_repos(payload), NO_ERROR]
  end

  def filter_public_repos(payload)
    EMPTY_REPOS if payload.blank?

    payload.map do |data|
      unless skip?(data)
        data.slice('name', 'html_url')
      end
    end.compact
  end

  def skip?(data)
    data['private'] || data['fork']
  end
end
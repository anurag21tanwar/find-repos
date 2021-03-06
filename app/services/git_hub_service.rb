# frozen_string_literal: true

class GitHubService
  include Responses, Memoize
  API_URL = 'https://api.github.com/users/??/repos'

  attr_accessor :username

  def initialize(username)
    @username = username
  end

  def call
    if present_in_cache?(username)
      read_from_cache(username)
    else
      res = response
      write_in_cache(username, res)
      res
    end
  end

  private

  def response
    return blank_username_response if username.blank?

    response = fetch_repos
    case response.code
    when '200'
      format_response(response.body)
    when '404'
      username_not_found_response
    else
      failure_response(response)
    end
  rescue StandardError => e
    Rails.logger.error { e.backtrace.first(25).join("\n") }
    error_response(e)
  end

  def fetch_repos
    uri = URI(API_URL.gsub('??', username))
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
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
      data.slice('name', 'html_url') unless skip?(data)
    end.compact
  end

  def skip?(data)
    data['private'] || data['fork']
  end
end

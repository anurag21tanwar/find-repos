# frozen_string_literal: true

module ResponseHelper
  def blank_username_response
    [EMPTY_REPOS, 'blank username']
  end

  def empty_response
    [EMPTY_REPOS, 'not able to get response from github, try again..']
  end

  def username_not_found_response
    [EMPTY_REPOS, 'username not found']
  end

  def failure_response(response)
    [EMPTY_REPOS, format_message("unsuccessful response from github, http_code:#{response.code}")]
  end

  def error_response(err)
    [EMPTY_REPOS, format_message(err.message)]
  end

  private

  def format_message(message)
    message.downcase
  end
end

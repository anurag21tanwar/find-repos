# frozen_string_literal: true

require 'rails_helper'
RSpec.describe '/search', type: :request do
  let(:username) { 'dd' }
  let(:body) do
    [{
      name: 'XYZ',
      private: false,
      fork: false,
      html_url: "https://github.com/#{username}/XYZ"
    }]
  end

  before do
    stub_request(:get, "https://api.github.com/users/#{username}/repos").to_return(status: 200, body: body.to_json)
  end

  it 'successful' do
    get search_repos_path(username: username)
    expect(response).to be_successful
  end

  it 'response body' do
    get search_repos_path(username: username)
    expect(response.body).to include('<li><a target="_blank" href="https://github.com/dd/XYZ">XYZ</a></li>')
  end
end

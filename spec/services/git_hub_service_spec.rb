# frozen_string_literal: true

require 'rails_helper'
RSpec.describe GitHubService, type: :class do
  let(:username) { 'dd' }
  let(:status) { 200 }
  let(:body) do
    [
      {
        name: 'XYZ',
        private: false,
        fork: false,
        html_url: "https://github.com/#{username}/XYZ"
      },
      {
        name: 'ABC',
        private: true,
        fork: false,
        html_url: "https://github.com/#{username}/ABC"
      },
      {
        name: 'MNK',
        private: false,
        fork: true,
        html_url: "https://github.com/#{username}/MNK"
      }
    ]
  end

  subject { described_class.new(username) }

  before do
    stub_request(:get, "https://api.github.com/users/#{username}/repos").to_return(status: status, body: body.to_json)
  end

  context 'when empty username' do
    let(:username) { '' }
    it 'should return blank_username_response' do
      expect(subject.call).to eq([[], 'blank username'])
    end
  end

  context 'when 200' do
    it 'should return only public repos' do
      expect(subject.call).to eq([[{ 'html_url' => 'https://github.com/dd/XYZ', 'name' => 'XYZ' }], nil])
    end

    context 'when no repo exists' do
      let(:body) { [] }

      it 'should return no repos' do
        expect(subject.call).to eq([[], nil])
      end
    end
  end

  context 'when 404' do
    let(:username) { 'someUsername' }
    let(:status) { 404 }
    let(:body) do
      { message: 'not found' }
    end

    it 'should return username_not_found_response' do
      expect(subject.call).to eq([[], 'username not found'])
    end
  end

  context 'when 500' do
    let(:status) { 500 }
    let(:body) { nil }

    it 'should return failure_response' do
      expect(subject.call).to eq([[], 'unsuccessful response from github, http_code:500'])
    end
  end

  context 'when timeout' do
    before do
      stub_request(:get, "https://api.github.com/users/#{username}/repos").to_timeout
    end

    it 'should return error_response' do
      expect(subject.call).to eq([[], 'execution expired'])
    end
  end
end

class RepoSearchService
  attr_accessor :username

  def initialize(username)
    @username = username
  end

  def call
    []
  end
end
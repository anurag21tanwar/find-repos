# Anurag's fetch-repo

Hi,

app info:
1) fetch-repo rails app uses rails 6.1.4 and ruby 2.7.0
2) rubocop for code quality
3) rspec for unit tests
6) simplecov for test coverage

flow:
1) home controller to handle request
2) GitHubService fetch repos via username and filters all private and forked repos
3) app also memoize the result for 2 mins so that we dont need to call github again and again

test:
1) to see test coverage, run bundle exec rspec and open tmp/coverage/index.html

steps to run app:
1) clone repos: git clone git@github.com:anurag21tanwar/find-repos.git
2) cd in dir: cd find-repos
3) run bundle: bundle install
4) enable cache in dev env: rails dev:cache
5) start server: rails s
6) open browser: localhost:3000
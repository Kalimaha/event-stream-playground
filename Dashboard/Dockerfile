FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /Dashboard
WORKDIR /Dashboard
ADD Gemfile /Dashboard/Gemfile
ADD Gemfile.lock /Dashboard/Gemfile.lock
RUN bundle install
ADD . /

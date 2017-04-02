FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /Warehouse
WORKDIR /Warehouse
RUN export TMPDIR="/tmp"
ADD Gemfile /Warehouse/Gemfile
ADD Gemfile.lock /Warehouse/Gemfile.lock
RUN bundle install
ADD . /

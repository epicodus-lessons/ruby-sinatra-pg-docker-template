FROM ruby:2.6.5

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]

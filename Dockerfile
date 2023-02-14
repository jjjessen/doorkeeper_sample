FROM ruby:3.2.0

# based on https://github.com/timbru31/docker-ruby-node/blob/master/3.1/16/Dockerfile
RUN curl -sL https://deb.nodesource.com/setup_19.x | bash -\
  && apt-get update -qq && apt-get install -qq --no-install-recommends \
    postgresql-client nodejs redis-tools \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app

RUN yarn install

ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

EXPOSE 3000

CMD "bin/dev"

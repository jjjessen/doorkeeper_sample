FROM ruby:3.2.2

RUN apt-get update -qq \
  && apt-get install -qq --no-install-recommends \
    postgresql-client redis-tools libvips42 vim -y ca-certificates curl gnupg graphviz \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_21.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
  && apt-get update -qq \
  && apt-get install -qq nodejs -y \
  && npm install -g yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app
RUN ["chmod", "+x", "/app/bin/docker-entrypoint-web"]

RUN yarn install

ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

EXPOSE 3000

CMD "bin/dev"

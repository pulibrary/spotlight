ARG RUBY_VERSION=4.0.9
ARG ALPINE_VERSION=3.24
FROM ruby:$RUBY_VERSION-alpine$ALPINE_VERSION

ARG RAILS_VERSION=8.1.4.1

ENV SPOTLIGHT_ENGINE_PATH=/spotlight/engine
ENV SPOTLIGHT_GEM=/spotlight/engine
ENV RAILS_QUEUE=inline

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  build-base \
  curl \
  gcompat \
  git \
  imagemagick \
  less \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  npm \
  shared-mime-info \
  sqlite-dev \
  tini \
  tzdata \
  yarn \
  zip

RUN addgroup --gid 10001 --system spotlight && \
  adduser --uid 10000 --system \
  --ingroup spotlight --home /spotlight spotlight

RUN npm i -g npx

USER spotlight
RUN gem install bundler -v "~> 2.7"
RUN gem install --no-document rails -v "${RAILS_VERSION}"

COPY --chown=10000:10001 . /spotlight/engine
WORKDIR /spotlight/engine
RUN bundle install --jobs "$(nproc)"

RUN mkdir -p /spotlight/app
WORKDIR /spotlight/app

RUN SKIP_TRANSLATION=yes rails _${RAILS_VERSION}_ new . --force --template=../engine/template.rb
RUN SKIP_TRANSLATION=yes DB_ADAPTER=nulldb  bundle exec rake assets:precompile

ENTRYPOINT ["/sbin/tini", "--", "/spotlight/engine/bin/docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]

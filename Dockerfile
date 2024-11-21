FROM ruby:3.3.6

# Install bare dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    ffmpeg \
    cron \
    libsqlite3-dev \
    nodejs \
    yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV RAILS_ROOT /myapp

RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile* ./
RUN gem install bundler

# RAILS_MASTER_KEY != blank --> production mode
ARG RAILS_MASTER_KEY=""
RUN test -z "$RAILS_MASTER_KEY" || bundle config set without 'development test'

RUN bundle install -j 20 -r 5 && bundle clean --force

COPY . $RAILS_ROOT

RUN test -z "$RAILS_MASTER_KEY" || RAILS_ENV=production rake assets:precompile

EXPOSE 3000 80

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]

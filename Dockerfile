FROM public.ecr.aws/docker/library/ruby:3.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  bash \
  nodejs \
  default-mysql-client \
  build-essential \
  default-libmysqlclient-dev \
  imagemagick \
  && rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler -v 2.4.13

WORKDIR /myapp

# Copy Gemfile for caching
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copy app code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=placeholder 2>/dev/null || true

# Entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]

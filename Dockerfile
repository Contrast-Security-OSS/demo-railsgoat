# Multistage docker build which first builds and bundles all Ruby gems before 
# creating build targets for the development and production images. 

# SETUP
# Default Ruby version for this project.
ARG RUBY_VERSION=3.0.6

# Base Alpine Ruby image for common setup
FROM ruby:$RUBY_VERSION-alpine as base

# Set some environment variables
# ENV BUNDLER_VERSION=2.4.4
ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV RAILS_ENV development
ENV RACK_ENV development

# Add basic packages that are shared across all stages
RUN apk add --no-cache \
    nodejs \
    tzdata

# Builder stage for building Ruby gems
FROM base as builder

# Add packages for required for building
RUN apk add --no-cache \
    autoconf \
    build-base \
    libpq-dev \
    mariadb-dev

# Set the working directory for the app. 
WORKDIR /app                          

# Copy the Gemfile and Gemfile.lock files to the current directory.
COPY Gemfile* .

# Install bundler with specified version.
# RUN gem install bundler -v $BUNDLER_VERSION

# Install gems and remove any unnecessary files from gems. 
RUN bundle config force_ruby_platform true \
    && bundle install --jobs 4 --retry 3 \ 
    && rm -rf $BUNDLE_PATH/cache/*.gem \
    && rm -rf $BUNDLE_PATH/ruby/*/cache 
    # && find $BUNDLE_PATH/gems/ -name "*.c" -delete \
    # && find $BUNDLE_PATH/gems/ -name "*.o" -delete


# RUNNER STAGE 
FROM base as runner

RUN apk add --no-cache \
    libpq \
    mariadb

WORKDIR /app

# Copy the bundle directory from the "builder" image 
# and copy all other files to the current directory. 
COPY --from=builder $BUNDLE_PATH $BUNDLE_PATH
COPY . . 

# Recreate, migrate and seed the database from scratch 
# each time the container is built
# RUN rm db/development.sqlite3 db/test.sqlite3 \
#     && bundle exec rails db:setup

# Expose port 3000 for the application.
EXPOSE 3000

# Run the command to start the Rails server.
# ENTRYPOINT ["/bin/bash"]
CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]



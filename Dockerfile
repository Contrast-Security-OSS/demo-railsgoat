# Multistage docker build which first builds and bundles all Ruby gems before 
# creating build targets for the development and production images. 

# Default Ruby version for this project.
ARG RUBY_VERSION=3.1.4

# BASE STAGE
# Create a base ruby-alpine stage with common configuration
# that can be used in all other stages.
FROM ruby:$RUBY_VERSION-alpine as ruby-alpine

# Set environment variables to be shared across all stages.
ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV RAILS_ENV development
ENV RACK_ENV development

# Add basic packages that are shared across all stages
RUN apk add --no-cache \
    nodejs \
    tzdata

# BUILDER STAGE
# Build all gems and dependencies in a builder stage, 
# whch can then be copied to other stages.
FROM ruby-alpine as builder

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

# Install gems and remove any unnecessary build artifacts. 
RUN bundle config force_ruby_platform true \
    && bundle install --jobs 4 --retry 3 \ 
    && rm -rf $BUNDLE_PATH/cache/*.gem \
    && rm -rf $BUNDLE_PATH/ruby/*/cache

# RUNNER STAGE 
# Copy the needed gems and dependenies from the builder stage to 
# create the final minimal image for running the app.
FROM ruby-alpine as runner

# Add packages required for running the app
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    libpq \
    mariadb

# Set the working directory for the app.
WORKDIR /app

# Copy the bundle directory from the "builder" image 
# and copy all other files to the current directory. 
COPY --from=builder $BUNDLE_PATH $BUNDLE_PATH
COPY . . 

# Expose port 3000 for the application.
EXPOSE 3000

# Run the command to start the Rails server.
ENTRYPOINT ["/bin/sh"]
CMD ["/app/entrypoint.sh"]

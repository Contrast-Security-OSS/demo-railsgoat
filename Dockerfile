# TODO: change to slim or alpine
FROM ruby:2.6.2

ARG username
ARG service_key

# Add build and runtime dependencies
# TODO: separate build & runtime and purge build dependencies at the end
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Install phantomjs dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        bzip2 \
        libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install phantomjs & clean up
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
    && mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
           | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && cd /tmp/phantomjs \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
        curl \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

# Build and package the app
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock

# Add Contrast agent
RUN bundle add contrast-agent

RUN bundle install

ADD ./app /myapp/app
ADD ./config /myapp/config
ADD ./db /myapp/db
ADD ./doc /myapp/doc
ADD ./lib /myapp/lib
ADD ./log /myapp/log
ADD ./public /myapp/public
ADD ./script /myapp/script
ADD ./spec /myapp/spec
RUN mkdir /myapp/tmp
ADD ./vendor /myapp/vendor
ADD ./config.ru /myapp/config.ru
ADD ./entrypoint.sh /myapp/entrypoint.sh
ADD ./Rakefile /myapp/Rakefile

#Setup the database
RUN rails db:setup

# Make port 3000 available
EXPOSE 3000

# Start the app server
ENTRYPOINT [ "/bin/bash", "-c", "/myapp/entrypoint.sh"]
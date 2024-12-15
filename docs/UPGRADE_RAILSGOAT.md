# Upgrading Rails and Ruby versions for RailsGoat
This guide is intended for Contrast maintainers who are upgrading the version of Ruby and/or Rails used by RailsGoat. 

## Why Upgrade?
We will need to keep the version of RailsGoat within the versions supported by Ruby on Rails **and** the Contrast Ruby Agent for this demo app to remain operational. We may also want to take advantage of new features and performance enhancements offered by the latest versions of the Contrast Ruby Agent.

* See the [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/) schedule for specific release dates.
* See the [Contrast Ruby Agent Supported Technologies](https://docs.contrastsecurity.com/en/ruby-supported-technologies.html) for the currently supported versions of Ruby and Rails.

## How to upgrade RailsGoat
Upgrading the version of Ruby, Rails or Bundler that this app uses should be done using the provided Dockerfile, as this will provide the most repeatable results. 

Follow the [Upgrading Ruby on Rails](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html) guide from the official documentation. Read through this guide first if you are not familiar. 

**General tips for a successful upgrade:**
* Upgrade Ruby and Rails separately, building the Dockerfile and dealing with any issues, bugs, or deprecation warnings as you go. 
* Run the rspec tests in between each build to ensure that no functionality is broken.
* Ruby can be upgraded one major version at a time (first jump to the last minor version of your current version, test, and then continue the upgrade to the next major version)
* Don't upgrade Ruby past the [last ruby version supported by your current version of rails](https://www.fastruby.io/blog/ruby/rails/versions/compatibility-table.html). 
* Rails needs to be updated **one minor version at a time** (version format: `major.minor.patch`). This is to make running `rails app:update` command easier, which will attempt to apply the changes required to your codebase.
* When running `rails app:update`, you will be prompted to overwrite files. Please view the diffs of these changes and test the changes before committing.

### Upgrading Ruby
First upgrade the Ruby version to your target Ruby version in the Dockerfile, the Gemfile and the .ruby-version files. 

Dockerfile:
```Dockerfile
...
# Default Ruby version for this project.
ARG RUBY_VERSION=3.1.4   <---   

# Base Alpine Ruby image for common setup
FROM ruby:$RUBY_VERSION-alpine as base
...
```

Gemfile:
```Gemfile
...
# frozen_string_literal: true
source "https://rubygems.org"

gem "rails", "5.2.8"

ruby "2.7.7"    <---
...
```

Now rebuild the container,test the app and make sure the gems are fully up to date:
```bash 
docker compose up --build
docker compose exec web sh 
> bundle update
> bundle install
```

### Upgrading Rails
Now that you have upgraded Ruby, you can upgrade Rails. Change the version number for rails in the Gemfile:

```Gemfile 
# frozen_string_literal: true
source "https://rubygems.org"

gem "rails", "6.1.7"        <---

ruby "3.1.4"
```

Rerun the step above to rebuild the container, attach to it and then update gems again.
```bash 
docker compose up --build
docker compose exec web sh 
> bundle update
> bundle install
```

You can also use the rails update command to implement any of the changes required by the new version of Rails. This will prompt you to overwrite files, so make sure you view the diffs and test the changes before committing. 

```bash
docker compose exec web sh 
> bin/bash app:update
```

Now test the app for any errors or deprecation warnings, fix them, run tests, and commit your changes.

#### Upgrade bundler
It's unlikely, but you may also need to upgrade bundler if you are getting errors. You can do this by running `bundle update --bundler`. The default version of bundler from the ruby container should be preferred.

#### Migrating and seeding the database
If database migrations were created by the update process, you will need to run them and then seed the database. 

```bash
docker compose exec web bin/rails db:migrate
```

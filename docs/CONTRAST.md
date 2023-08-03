# Contrast specific changes
Documentation of the changes made to RailsGoat to add Contrast Security to the project.

## Changelog to add Contrast to this project
* `contrast_security.yml` configuration file added to the `config/` directory
* `.env` configuration file added to the root directory
* `gem 'contrast-agent'` added to the `Gemfile`

## Other changes to RailsGoat (Not required for Contrast)
* Upgraded to Ruby `3.1.4`
* Upgraded to Rails `6.1.7`
* Improved the `Dockerfile` to use a multi-stage build and Alpine Linux
* Updated the `docker-compose` file to start two services: `dev` and `prod`
* Fixed issues with loading javascript and rendering graphs on multiple pages

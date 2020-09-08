# Introduction
This project includes an example implementation of the Contrast Ruby agent within the vulnerable RailsGoat application.

#  Build Pre-Requisites
* Ruby on Rails 5.x
* Git
* MySQL

# Structure
* entrypoint.sh: Entrypoint for container start.
  * Starts rails server
* package.sh: Unnecessary; only exists for consistency with other demo applications.
* acr.sh: Contains commands for pushing image to Azure Container Registry.
* image.sh: Builds new Docker image:
  * Uses CONTRAST_USERNAME and CONTRAST_SERVICE_KEY environment variables to get latest agent from Eval
  * Builds new railsgoat Docker image with "latest" tag.

# Build Instructions
```bash
$ CONTRAST_USERNAME=<YOUR_CONTRAST_USERNAME> CONTRAST_SERVICE_KEY=<YOUR_CONTRAST_SERVICE_KEY> ./image.sh
```

# Running Locally
```bash
docker run \
    -e CONTRAST__URL=https://eval.contrastsecurity.com/Contrast \
    -e CONTRAST__API__API_KEY=<YAML_API_KEY> \
    -e CONTRAST__API__SERVICE_KEY=<YAML_SERVICE_KEY> \
    -e CONTRAST__API__USER_NAME=<YAML_USER_NAME> \
    -e CONTRAST__APPLICATION__NAME=<YOUR_APP_NAME> \
    -e CONTRAST__SERVER__ENVIRONMENT=<development, qa or production> \
    -rm -p 3000:3000 railsgoat:latest
```

# Running in Azure with Terraform



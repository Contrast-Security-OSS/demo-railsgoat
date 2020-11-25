# RailsGoat: A deliberately insecure Ruby web application

This is a Ruby demo application, based on https://github.com/OWASP/railsgoat.

**Warning**: The computer running this application will be vulnerable to attacks, please take appropriate precautions.

# Running standalone

You can run RailGoat locally on any machine with Ruby and Rails 5.x installed.

1. Place a `contrast_security.yaml` file into the application's root folder.

1. Install the Contrast agent using: 
```sh
  bundle add contrast-agent
  bundle install
```
3. Initialize the database:
```sh
  rails db:setup
```
4. Start the Thin web server:

```sh
  rails server
```
5. Browse the application at http://localhost:3000

# Running in Docker

You can run RailsGoat within a Docker container, tested on OSX. The agent is added automatically during the Docker build process.

1. Place a `contrast_security.yaml` file into the application's root folder.
1. Build the RailsGoat container image using `./1-Build-Docker-Image.sh`
1. Run the container using
```sh
docker run \
  -v $PWD/contrast_security.yaml:/myapp/contrast_security.yaml \
  -e CONTRAST__APPLICATION__NAME=railsgoat \
  -p 3000:3000 railsgoat:latest 
```
4. Browse the application at http://localhost:3000

# Running in Azure (Azure App Service):

## Pre-Requisites

1. Place a `contrast_security.yaml` file into the application's root folder.
1. Install Terraform from here: https://www.terraform.io/downloads.html.
1. Install PyYAML using `pip install PyYAML`.
1. Install the Azure cli tools using `brew update && brew install azure-cli`.
1. Log into Azure to make sure you cache your credentials using `az login`.
1. Edit the [variables.tf](variables.tf) file (or add a terraform.tfvars) to add your initials, preferred Azure location, app name, server name and environment.
1. Run `terraform init` to download the required plugins.
1. Run `terraform plan` and check the output for errors.
1. Run `terraform apply` to build the infrastructure that you need in Azure, this will output the web address for the application.
1. Run `terraform destroy` when you would like to stop the app service and release the resources.

## Running automated tests

RailsGoat includes a set of failing Capybara RSpecs, each one indicating that a separate vulnerability exists in the application. To run them, you first need to install [PhantomJS](https://github.com/jonleighton/poltergeist#installing-phantomjs) (version 2.1.1 has been tested in Dev and on Travis CI), which is required by the Poltergeist Capybara driver. Upon installation, simply run the following task:

```sh
rails training
```

For Docker run:

```sh
docker run \
  -v $PWD/contrast_security.yaml:/myapp/contrast_security.yaml \
  -e CONTRAST__APPLICATION__NAME=railsgoat \
  -e TEST=true \
  -p 3000:3000 railsgoat:latest
```

## Updating the Docker Image

You can re-build the docker image (used by Terraform) by running two scripts in order:

* 1-Build-Docker-Image.sh
* 2-Deploy-Docker-Image-To-Docker-Hub.sh

# License

[The MIT License (MIT)](./LICENSE.md)

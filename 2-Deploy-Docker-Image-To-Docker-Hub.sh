#!/bin/bash

echo "Please log in using your Docker Hub credentials to update the container image"
docker login
docker tag railsgoat:1.0 contrastsecuritydemo/railsgoat:1.0
docker push contrastsecuritydemo/railsgoat:1.0
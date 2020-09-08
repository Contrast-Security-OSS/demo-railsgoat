#### Azure Terraform Variables ####

variable "initials" {
  description = "Enter your initials to include in URLs. Lowercase only!!!"
  default = ""
}

variable "location" {
  description = "The Azure location where all resources in this example should be created, to find your nearest run `az account list-locations -o table`"
  default = ""
}

variable "appname" {
  description = "The name of the app to display in Contrast TeamServer. Also used for DNS, so no spaces please!"
  default = "RailsGoat"
}

variable "servername" {
  description = "The name of the server to display in Contrast TeamServer."
  default = "railsgoat-docker"
}

variable "environment" {
  description = "The Contrast environment for the app. Valid values: development, qa or production"
  default = "development"
}

variable "session_metadata" {
  description = "See https://docs.contrastsecurity.com/user-vulnerableapps.html#session"
  default = ""
}

variable "run_automated_tests" {
  description = "Instructs the container to run the Ruby feature specs (integration tests)"
  default = false
}

variable "python_binary" {
  description = "Path to local Python binary"
  default = "python"
}
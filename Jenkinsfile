env.terraform_version = '0.12.3'

pipeline {
    agent any

    stages {
        stage('dependencies') {
            steps {
                sh """
                FILE=/usr/bin/terraform
                if [ -f "\$FILE" ]; then
                    echo "\$FILE exists, skipping download"
                else
                    echo "\$FILE does not exist"
                    cd /tmp
                    curl -o terraform.zip https://releases.hashicorp.com/terraform/'$terraform_version'/terraform_'$terraform_version'_linux_amd64.zip
                    unzip -o terraform.zip
                    sudo mv terraform /usr/bin
                    rm -rf terraform.zip
                fi
                """
                script {
                    withCredentials([file(credentialsId: env.contrast_yaml, variable: 'path')]) {
                        def contents = readFile(env.path)
                        writeFile file: 'contrast_security.yaml', text: "$contents"
                    }
                }
                sh """
                terraform init
                """
            }
        }
        stage('provision') {
            steps {
                script {
                    env.GIT_SHORT_COMMIT = checkout(scm).GIT_COMMIT.take(7)
                    env.GIT_BRANCH = checkout(scm).GIT_BRANCH

                    withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                        try {
                            sh """
                            export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                            export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                            export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                            export ARM_TENANT_ID=$AZURE_TENANT_ID

                            terraform apply -auto-approve -var 'location=$location' -var 'initials=$initials' -var 'environment=qa' -var 'servername=jenkins' -var 'session_metadata="branchName=${env.GIT_BRANCH},buildNumber=${BUILD_NUMBER},commitHash=${env.GIT_SHORT_COMMIT},version=1.0"' -var 'run_automated_tests=true'
                            """
                        } catch (Exception e) {
                            echo "Terraform refresh failed, deleting state"
                            sh "rm -rf terraform.tfstate"
                            currentBuild.result = "FAILURE"
                            error("Aborting the build.")
                        }
                    }
                }
            }
        }
        stage('sleeping') {
            steps {
                sleep 120
            }
        }
        stage('destroy') {
            steps {
                withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                    sh """
                    export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                    export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                    export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                    export ARM_TENANT_ID=$AZURE_TENANT_ID
                    terraform destroy -auto-approve
                    """
                }
            }
        }
    }
}

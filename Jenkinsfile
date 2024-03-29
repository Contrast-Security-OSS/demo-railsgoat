pipeline {
    agent any
    tools {
        terraform 'terraform'
    }

    stages {
        stage('dependencies') {
            steps {
                script {
                    withCredentials([file(credentialsId: env.contrast_yaml, variable: 'path')]) {
                        def contents = readFile(env.path)
                        writeFile file: 'contrast_security.yaml', text: "$contents"
                    }
                }
                sh '''
                terraform init -upgrade
                '''
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

                            terraform apply -auto-approve -var 'location=$location' \
                                -var 'initials=$initials' \
                                -var 'environment=qa' \
                                -var 'servername=jenkins' \
                                -var 'session_metadata=branchName=${env.GIT_BRANCH},buildNumber=${BUILD_NUMBER},commitHash=${env.GIT_SHORT_COMMIT},version=1.0' \
                                -var 'run_automated_tests=true'
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
        stage('provision - dev') {
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

                            terraform apply -auto-approve -var 'location=$location' \
                                -var 'initials=$initials' \
                                -var 'environment=development' \
                                -var 'servername=Macbook-Pro' \
                                -var 'session_metadata=branchName=${env.GIT_BRANCH},buildNumber=${BUILD_NUMBER},commitHash=${env.GIT_SHORT_COMMIT},version=1.0' \
                                -var 'run_automated_tests=true'
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
        stage('sleeping - dev') {
            steps {
                sleep 120
            }
        }
        stage('provision - prod') {
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

                            terraform apply -auto-approve -var 'location=$location' -var 'initials=$initials' -var 'environment=production' -var 'servername=Prod-01' -var 'session_metadata=branchName=${env.GIT_BRANCH},buildNumber=${BUILD_NUMBER},commitHash=${env.GIT_SHORT_COMMIT},version=1.0' -var 'run_automated_tests=true'
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
        stage('sleeping - prod') {
            steps {
                sleep 120
            }
        }
        stage('destroy') {
            steps {
                withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                    sh """
                    export ARM_CLIENT_ID=\$AZURE_CLIENT_ID
                    export ARM_CLIENT_SECRET=\$AZURE_CLIENT_SECRET
                    export ARM_SUBSCRIPTION_ID=\$AZURE_SUBSCRIPTION_ID
                    export ARM_TENANT_ID=\$AZURE_TENANT_ID
                    terraform destroy --auto-approve \
                        -var 'location=$location'
                    """
                }
            }
        }
    }
}

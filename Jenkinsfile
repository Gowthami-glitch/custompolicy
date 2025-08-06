pipeline {
    agent any

    environment {
        // Azure Service Principal credentials stored in Jenkins
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')   // store as "Secret Text"
        ARM_CLIENT_ID       = credentials('azure-client-id')         // store as "Secret Text"
        ARM_CLIENT_SECRET   = credentials('azure-client-secret')     // store as "Secret Text"
        ARM_TENANT_ID       = credentials('azure-tenant-id')         // store as "Secret Text"

        // SonarQube token
        SONAR_AUTH_TOKEN = credentials('sonar-token')                 // store as "Secret Text"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Gowthami-glitch/custompolicy'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                        ${tool 'sonarqube'}/bin/sonar-scanner \
                          -Dsonar.organization=gowthami-glitch \
                          -Dsonar.projectKey=Gowthami-glitch_custompolicy \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=https://sonarcloud.io \
                          -Dsonar.login=${SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh """
                terraform validate \
                  -var "subscription_id=${ARM_SUBSCRIPTION_ID}" \
                  -var "client_id=${ARM_CLIENT_ID}" \
                  -var "client_secret=${ARM_CLIENT_SECRET}" \
                  -var "tenant_id=${ARM_TENANT_ID}"
                """
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                terraform plan \
                  -var "subscription_id=${ARM_SUBSCRIPTION_ID}" \
                  -var "client_id=${ARM_CLIENT_ID}" \
                  -var "client_secret=${ARM_CLIENT_SECRET}" \
                  -var "tenant_id=${ARM_TENANT_ID}" \
                  -out=tfplan.out
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                terraform apply -auto-approve tfplan.out
                """
            }
        }
    }
}

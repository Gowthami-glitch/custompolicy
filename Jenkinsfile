pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('azure-sp')              // Client ID of lucky
        ARM_CLIENT_SECRET   = credentials('azure-sp-secret')       // Secret Value of lucky
        ARM_TENANT_ID       = credentials('azure-tenant')          // Tenant ID
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription')    // Subscription ID
        SONAR_AUTH_TOKEN    = credentials('sonar-token')           // SonarQube token
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/Gowthami-glitch/custompolicy'
            }
        }

       stage('SonarQube Analysis') {
    steps {
        script {
            withSonarQubeEnv('sonarqube') {
                sh """
                    sonar-scanner \
                      -Dsonar.organization=gowthami-glitch \
                      -Dsonar.projectKey=Gowthami-glitch_custompolicy \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=https://sonarcloud.io \
                      -Dsonar.login=$SONAR_AUTH_TOKEN
                """
            }
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
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan.out'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan.out'
            }
        }
    }

    post {
        always {
            script {
                node {
                    cleanWs()
                }
            }
        }
    }
}

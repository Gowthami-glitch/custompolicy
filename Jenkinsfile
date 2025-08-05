pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('azure-sp')     // Client ID of lucky
        ARM_CLIENT_SECRET   = credentials('azure-sp-secret') // Secret Value of lucky
        ARM_TENANT_ID       = credentials('azure-tenant') // Tenant ID
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription') // Subscription ID
    }

    stages {
        stage('Checkout') {
            steps {
               git branch: 'main',
    credentialsId: 'github-creds',
    url: 'https://github.com/Gowthami-glitch/custompolicy.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarserver') {
                    sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=custompolicy \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=$SONAR_HOST_URL \
                      -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }

        stage('Azure Login') {
            steps {
                sh '''
                az login --service-principal \
                    -u $ARM_CLIENT_ID \
                    -p $ARM_CLIENT_SECRET \
                    --tenant $ARM_TENANT_ID
                az account set --subscription $ARM_SUBSCRIPTION_ID
                '''
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
            cleanWs()
        }
    }
}

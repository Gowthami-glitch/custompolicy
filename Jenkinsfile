pipeline {
    agent any

    environment {
        SONARQUBE = 'sonarqube' // SonarQube installation name in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Gowthami-glitch/custompolicy'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                        /var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonarqube/bin/sonar-scanner \
                        -Dsonar.organization=gowthami-glitch \
                        -Dsonar.projectKey=Gowthami-glitch_custompolicy \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=https://sonarcloud.io
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'azure-tenant', variable: 'ARM_TENANT_ID'),
                    string(credentialsId: 'azure-subscription', variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'azure-sp', variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'azure-sp-secret', variable: 'ARM_CLIENT_SECRET')
                ]) {
                    sh '''
                        export ARM_TENANT_ID=$ARM_TENANT_ID
                        export ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
                        export ARM_CLIENT_ID=$ARM_CLIENT_ID
                        export ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET

                        terraform init
                    '''
                }
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
                input(message: 'Do you want to apply the Terraform changes?')
                sh 'terraform apply -auto-approve tfplan.out'
            }
        }
    }
}

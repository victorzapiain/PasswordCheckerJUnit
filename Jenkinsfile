pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "victorzapiain/password-checker"
        DOCKER_TAG = "latest"
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm: [
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/victorzapiain/PasswordCheckerJUnit.git',
                        credentialsId: 'GithubToken'
                    ]]
                ]
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.image('cimg/openjdk:17.0').inside {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Match Java version with build stage
                    docker.image('cimg/openjdk:17.0').inside {
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Also use Java 17 to ensure compatibility
                    docker.image('cimg/openjdk:17.0').inside {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
    }
}


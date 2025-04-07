pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "victorzapiain/password-checker"
        DOCKER_TAG = "latest"
        SONARQUBE_URL = "http://sonarqube:9000"  
        SONARQUBE = 'SonarQube Server'  
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
                    docker.image('cimg/openjdk:17.0').inside('--network ci_network') {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    docker.image('cimg/openjdk:17.0').inside('--network ci_network') {
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('SonarQube Connectivity Check') {
            steps {
                script {
                    echo "Testing SonarQube connectivity..."
                    sh "ping -c 4 sonarqube || echo 'Ping failed'"
                    sh "curl -v $SONARQUBE_URL || echo 'SonarQube not reachable'"
                }
            }
        }

        stage('SonarQube Analysis') {
            agent {
                docker {
                    image 'maven:3.8.6-eclipse-temurin-17'
                    args '--network ci_network'
                }
            }
            steps {
                withSonarQubeEnv(SONARQUBE) {
                    script {
                        echo "Running SonarQube analysis..."
                        withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONARQUBE_TOKEN')]) {
                            sh '''
                                mvn clean install sonar:sonar \
                                -Dsonar.host.url=$SONARQUBE_URL \
                                -Dsonar.login=$SONARQUBE_TOKEN \
                                -X
                            '''
                        }
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


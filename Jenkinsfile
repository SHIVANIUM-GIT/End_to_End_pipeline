pipeline {
    agent any
    stages {
        stage('SCM') {
            steps {
                git 'https://github.com/SHIVANIUM-GIT/devops_project.git'
            }
        }
        stage('Build Docker OWN Image') {
            steps {
                sh " docker build -t docker.io/shivanium/webpage:${BUILD_NUMBER} ."
            }
        }
        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'Dock_Pass', variable: 'docker_password')]) {
                    sh " docker login -u shivanium -p ${docker_password}"
                    sh " docker push docker.io/shivanium/webpage:${BUILD_NUMBER}"
                }             
            }
        }
        stage('Deploy Webapp in dev env') {
            steps {
                sh " docker rm -f webpage || true "
                sh "  docker run -d -p 81:80 --name webpage shivanium/webpage:${BUILD_NUMBER} "           
            }
        }
        stage('Deploy on k8s') {
            steps {
                sh "minikube delete"
                sh "minikube start"
                sh "kubectl apply -f webpage.yml"
            }
        }
    }
}
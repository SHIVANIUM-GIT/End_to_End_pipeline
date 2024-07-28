pipeline {
    agent any

    stages {
        stage('SCM') {
            steps {
                git url: 'https://github.com/SHIVANIUM-GIT/devops_project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t docker.io/shivanium/webpage:${BUILD_NUMBER} .'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
                    script {
                        sh 'docker login -u shivanium -p ${docker_password}'
                        sh 'docker push docker.io/shivanium/webpage:${BUILD_NUMBER}'
                    }
                }
            }
        }

        stage('Deploy Webapp in Dev Env') {
            steps {
                script {
                    sh 'docker rm -f webpage || true'
                    sh 'docker run -d -p 81:80 --name webpage docker.io/shivanium/webpage:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy on Kubernetes') {
            steps {
                script {
                    sh "minikube start"
                    sh "docker system prune -a -f"
                    sh "kubectl delete deployment mywebpage || true" 
                    sh "kubectl create deployment mywebpage --image=docker.io/shivanium/webpage:${BUILD_NUMBER}" 
                    sh "kubectl scale deployment mywebpage --replicas=5" 
                }
            }
        }
    }
}

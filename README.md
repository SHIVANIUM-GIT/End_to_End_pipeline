
# End to End Pipeline

This repository contains a Jenkins pipeline script for automating the building, pushing, and deployment of a Dockerized web application. The pipeline also includes steps for deploying the application on Kubernetes using Minikube.

## Overview

The pipeline consists of the following stages:
1. **SCM**: Clones the source code from the GitHub repository.
2. **Build Docker OWN Image**: Builds a Docker image from the source code.
3. **Push Image to Docker Hub**: Pushes the Docker image to Docker Hub.
4. **Deploy Webapp in dev env**: Deploys the Docker container in a development environment.
5. **Deploy on k8s**: Deploys the application on a Kubernetes cluster using Minikube.


## Pipeline Script

```groovy
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
                sh " docker rm -f webpage "
                sh "  docker run -d -p 81:80 --name webpage shivanium/webpage:${BUILD_NUMBER} "           
            }
        }
        stage('Deploy on k8s') {
            steps {
                sh "minikube delete"
                sh "minikube start"
                sh "kubectl create deployment mywebpage --image=shivanium/webpage:${BUILD_NUMBER}"
                sh "kubectl apply -f webpage.yml"
                sh "kubectl scale deployment mywebpage --replicas=5"
            }
        }
    }
}
```

## Prerequisites

- Jenkins installed and configured.
- Docker installed on Jenkins agent.
- Minikube installed.
- Docker Hub account with credentials set up in Jenkins (credentials ID: `Dock_Pass`).

## Steps to Set Up

1. **Clone Repository:**
    ```sh
    git clone https://github.com/SHIVANIUM-GIT/devops_project.git
    ```

2. **Jenkins Configuration:**
    - Create a new Jenkins pipeline job.
    - Copy and paste the above pipeline script into the job's configuration.

3. **Run Pipeline:**
    - Trigger the pipeline to start the build and deployment process.

## Key Features

- **Automated Builds:** Automatically builds a new Docker image on each commit.
- **Secure Credentials Management:** Uses Jenkins credentials for Docker Hub login.
- **Continuous Deployment:** Deploys the application to a development environment and scales it on a Kubernetes cluster.

## Author

- **Shiv Kumar Rathore** - [GitHub](https://github.com/SHIVANIUM-GIT)

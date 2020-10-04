pipeline {
  agent any
  environment {
      registry = "momami/repoimage"
      registryCredential = 'dockerhub'
      dockerImage = ''
  }
  stages {
         stage('Back-end build') {
            agent {
                docker { 
                    image 'maven'
                    label 'master'  
                    args '-u root'
                 }
            }
            steps {
                sh 'mvn clean package'
                stash includes: 'target/DevOpsSpringHelloWorld-1.0-SNAPSHOT.jar', name: 'jarFile'
            }
         }
         stage("Build image") {
             steps {
                 unstash 'jarFile'
                 sh "ls"
                 //sh "docker build -t pettest ."
                 script {
                    dockerImage = docker.build("pettest", ".")
                 }
             }
         }
         stage("Send image to DockerHub") {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                          dockerImage.push()
                    }
                }
            }
         }
    }
 }

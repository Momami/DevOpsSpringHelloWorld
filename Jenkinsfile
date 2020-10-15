pipeline {
  agent any
  environment {
      registry = "momami/petclinic"
      registryCredential = 'dockerhub'
      dockerImage = ''
      container = ''
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
                script {
                   dockerImage = docker.build("${registry}", ".")
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
        stage("Delete local image") {
            steps {
                sh "docker rmi -f ${registry}"
            }
        }
    }
 }

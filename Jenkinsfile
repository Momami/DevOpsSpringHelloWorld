pipeline {
    agent any

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
                    def dockerImage = docker.build("pettest", ".")
                 }
             }
         }
         stage("Send image to DockerHub") {
            steps {
                script {
                    docker.withRegistry('https://registry-1.docker.io/v2/', 'docker-hub-credentials') {
                          dockerImage.push()
                    }
                }
            }
         }
    }
 }

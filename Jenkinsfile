pipeline {
  agent any
  environment {
      registry = "momami/petclinic"
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
         stage("Pull image") {
              steps {
                  sh "docker pull ${registry}"
              }
         }
         stage("Test image") {
               steps {
                   sh "docker run --name pet -itd -p 14002:8080 ${registry}"
                   script {
                       def code = sh(script: 'curl -s -o /dev/null -w %{http_code} http://localhost:14002', returnStdout: true).trim()
                       def response = sh(script: 'curl http://localhost:14002', returnStdout: true).trim()
                       if (code == 200 && response == "Hello, world!") {
                            echo "Test passed"
                       }
                       else {
                            echo "Test failed: ${code}, ${response}"
                            exit 1
                       }
                   }
               }
         }
    }
 }

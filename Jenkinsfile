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
            }
         }
         stage("Build image") {
             steps {
                 sh "ls"
                 sh "docker build ."
             }
         }

    }
 }

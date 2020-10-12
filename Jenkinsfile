pipeline {
  agent any
  environment {
      registry = "momami/petclinic"
      registryCredential = 'dockerhub'
      dockerImage = ''
      container = ''
  }
  stages {

         stage("Pull image") {
              steps {
                  script {
                    dockerImage = docker.image("$registry")
                  }
              }
         }
         stage("Test image") {
               steps {

                   script {
                       container = dockerImage.run("--name devops -itd -p 14002:8080")
                       def code = sh(script: 'curl -s -o /dev/null -w %{http_code} http://localhost:14002', returnStdout: true)
                       def response = sh(script: 'curl http://localhost:14002', returnStdout: true).trim()
                       echo
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
    post {
        always {
            script {
                container.stop()
                container.remove()
                dockerImage.remove()
            }
        }
    }
 }

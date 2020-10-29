def withDockerNetwork(Closure inner) {
  try {
    networkId = UUID.randomUUID().toString()
    sh "docker network create ${networkId}"
    inner.call(networkId)
  } finally {
    sh "docker network rm ${networkId}"
  }
}

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
                    withDockerNetwork{ n ->
                        dockerImage.withRun("--name devops --network ${n} -p 14002:8080") { c ->
                            docker.image('curlimages/curl')
                                .inside("""
                                    --name curl_container
                                    --network ${n}
                                    """) {
                                    sh 'sleep 3'
                                    def code = sh(script: 'curl -s -o /dev/null -w "%{http_code}" devops:8080', returnStdout: true)
                                    def response = sh(script: 'curl devops:8080', returnStdout: true).trim()
                                    assert code == "200" && response == "Hello, world!"

                            }
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            sh 'docker rmi -f $registry'
        }
    }
}

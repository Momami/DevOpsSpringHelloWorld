FROM maven

COPY target/DevOpsSpringHelloWorld-1.0-SNAPSHOT.jar /main.jar

ENTRYPOINT ["java",  "-jar", "/main.jar"]

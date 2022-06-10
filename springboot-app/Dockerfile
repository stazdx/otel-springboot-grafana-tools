# Download OpenTelemetryAgent
FROM curlimages/curl:7.81.0 AS OTEL_AGENT
ARG OTEL_AGENT_VERSION="1.12.1"
RUN curl --silent --fail -L "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_AGENT_VERSION}/opentelemetry-javaagent.jar" \
    -o "/tmp/opentelemetry-javaagent.jar"

# Build .JAR file
FROM gradle:7.1.1-jdk11-hotspot AS BUILD_IMAGE
COPY --chown=gradle:gradle . /home/gradle/src
RUN chmod +x /home/gradle/src/gradlew
WORKDIR /home/gradle/src
RUN gradle build -x test --no-daemon 

# Final image copying OTEL Agent and .JAR File
FROM gradle:7.1.1-jdk11-hotspot
ENV TIME_ZONE America/Lima
ENV TZ=$TIME_ZONE
ENV JAVA_OPTS "-Dspring.config.location=src/main/resources/application.yml"
COPY --from=OTEL_AGENT /tmp/opentelemetry-javaagent.jar /otel-javaagent.jar
COPY --from=BUILD_IMAGE /home/gradle/src/build/libs/*.jar /app.jar

ENTRYPOINT exec java -javaagent:/otel-javaagent.jar -jar /app.jar 

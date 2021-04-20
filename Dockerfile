FROM gradle:jre15-hotspot as builder
WORKDIR /home/gradle/pchl
COPY build.gradle .
COPY resources ./resources
COPY src ./src
RUN gradle build
ENTRYPOINT ["/bin/bash"]

FROM openjdk:15-slim as runtime
WORKDIR /app
COPY --from=builder /home/gradle/pchl/build/distributions/pchl.tar pchl.tar
RUN tar -xvf pchl.tar
WORKDIR /app/pchl
ENTRYPOINT [ "bin/pchl" ]
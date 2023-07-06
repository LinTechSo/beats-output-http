# Use the official Golang image as the base image for building Filebeat
FROM mocker.ir/golang:1.19 AS builder

# Set the working directory inside the container
WORKDIR /src/

# Clone the Filebeat repository from GitHub
COPY . .

# Build Filebeat
RUN cd filebeat && make filebeat

# Use a minimal Alpine Linux image as the base image for the final container
FROM mocker.ir/alpine:latest

# Copy the Filebeat binary from the builder stage to the final container
COPY --from=builder /src/filebeat/filebeat /usr/local/bin/filebeat

# Create a directory for Filebeat configuration files
RUN mkdir -p /etc/filebeat

# Copy the Filebeat configuration file to the container
COPY filebeat/filebeat.yml /etc/filebeat/filebeat.yml

# Set the Filebeat configuration file as the active one
CMD ["/usr/local/bin/filebeat", "-e", "-c", "/etc/filebeat/filebeat.yml"]

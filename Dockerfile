# Stage 1: Build the Go binary
FROM golang:latest AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app
# CGO_ENABLED=0 builds a statically linked binary
# GOOS=linux ensures the binary is built for a Linux environment
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o calendar-proxy .

# Stage 2: Create the final, small image
FROM alpine:latest

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/calendar-proxy .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
# The CALENDAR_URL environment variable should be set when running the container
CMD ["./calendar-proxy"]

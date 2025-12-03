# Makefile for the calendar-proxy project

# Variables
IMAGE_NAME ?= calendar-proxy
IMAGE_TAG ?= latest
IMAGE_FILE ?= $(IMAGE_NAME).tar

.PHONY: all build run clean docker-build docker-run save-image help

all: build

# Build the Go binary
build:
	@echo "Building calendar-proxy..."
	@go build -o calendar-proxy .

# Run the Go application
# You need to set the CALENDAR_URL environment variable
# Example: CALENDAR_URL="http://example.com/calendar.ics" make run
run:
	@echo "Running calendar-proxy..."
	@CALENDAR_URL=${CALENDAR_URL} go run .

# Clean the built binary and saved image
clean:
	@echo "Cleaning up..."
	@rm -f calendar-proxy $(IMAGE_FILE)

# Build the Docker image
docker-build:
	@echo "Building Docker image $(IMAGE_NAME):$(IMAGE_TAG)..."
	@docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

# Run the Docker container
# You need to set the CALENDAR_URL environment variable
# Example: CALENDAR_URL="http://example.com/calendar.ics" make docker-run
docker-run:
	@echo "Running Docker container..."
	@docker run -p 8080:8080 -e CALENDAR_URL=${CALENDAR_URL} $(IMAGE_NAME):$(IMAGE_TAG)

# Save the Docker image to a .tar file
save-image: docker-build
	@echo "Saving image $(IMAGE_NAME):$(IMAGE_TAG) to $(IMAGE_FILE)..."
	@docker save -o $(IMAGE_FILE) $(IMAGE_NAME):$(IMAGE_TAG)
	@echo "Image saved to $(IMAGE_FILE)"
	@echo "Load it on another machine using: docker load -i $(IMAGE_FILE)"

# Display help
help:
	@echo "Available commands:"
	@echo "  make build         - Build the Go binary"
	@echo "  make run           - Run the Go application (set CALENDAR_URL)"
	@echo "  make clean         - Clean the built binary and saved image"
	@echo "  make docker-build  - Build the Docker image"
	@echo "  make docker-run    - Run the Docker container (set CALENDAR_URL)"
	@echo "  make save-image    - Build and save the Docker image to a .tar file"
	@echo "  make help          - Display this help message"

.DEFAULT_GOAL := help

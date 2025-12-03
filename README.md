# Calendar Proxy

A simple Go proxy for iCalendar feeds. It fetches a calendar from a given URL, cleans the data by removing `<pre>` tags, and serves it with the correct `text/calendar` content type.

This is useful for calendar clients that have trouble with iCalendar feeds embedded in HTML.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Go](https://golang.org/doc/install) (for building from source)
- [Docker](https://docs.docker.com/get-docker/) (for running with Docker)
- [Docker Compose](https://docs.docker.com/compose/install/) (for running with Docker Compose)

### Installation

1.  Clone the repo
    ```sh
    git clone https://github.com/artubric/calendar-proxy.git
    ```
2.  Navigate to the project directory
    ```sh
    cd calendar-proxy
    ```

## Usage

You can run this project in several ways.

### Using `go`

1.  Build the binary:
    ```sh
    make build
    ```
2.  Run the binary, setting the `CALENDAR_URL` environment variable:
    ```sh
    CALENDAR_URL="http://example.com/calendar.ics" ./calendar-proxy
    ```
    Alternatively, you can use the `run` target in the Makefile:
    ```sh
    make run CALENDAR_URL="http://example.com/calendar.ics"
    ```

### Using `docker`

1.  Build the Docker image:
    ```sh
    make docker-build
    ```
2.  Run the Docker container:
    ```sh
    make docker-run CALENDAR_URL="http://example.com/calendar.ics"
    ```

### Using `docker-compose`

Before running `docker-compose up`, ensure that the Docker image has been built using `make docker-build`.

The `docker-compose.yml` file is pre-configured to run the proxy.

1.  Update the `CALENDAR_URL` in `docker-compose.yml` to your desired calendar URL.
2.  Start the service:
    ```sh
    docker-compose up -d
    ```

### Docker Image Management

You can save the built Docker image to a `.tar` file and transfer it to another machine.

1.  **Save the Docker image:**
    ```sh
    make save-image
    ```
    This will create a `calendar-proxy.tar` file in the project root.

2.  **Load the Docker image on another machine:**
    Transfer the `calendar-proxy.tar` file to the target machine and run:
    ```sh
    docker load -i calendar-proxy.tar
    ```

## Configuration

The following environment variable must be set for the application to work:

- `CALENDAR_URL`: The URL of the iCalendar feed to proxy.

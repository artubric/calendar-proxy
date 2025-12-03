package main

import (
	"calendar-proxy/internal/calendar"
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", calendar.ProxyHandler)

	server := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	// Channel to listen for OS signals
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, os.Interrupt, syscall.SIGTERM)

	// Goroutine to start the server
	go func() {
		fmt.Println("Server is listening on :8080")
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			fmt.Printf("Error starting server: %s\n", err)
			os.Exit(1)
		}
	}()

	// Block until a signal is received
	<-stop

	fmt.Println("Shutting down server...")

	// Create a context with a timeout for the shutdown
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Attempt to gracefully shut down the server
	if err := server.Shutdown(ctx); err != nil {
		fmt.Printf("Error shutting down server: %s\n", err)
	} else {
		fmt.Println("Server gracefully stopped")
	}
}
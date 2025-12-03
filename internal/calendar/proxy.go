package calendar

import (
	"fmt"
	"io"
	"net/http"
	"os" // Import the os package
	"strings"
)

const calendarURLEnv = "CALENDAR_URL" // Environment variable name

// ProxyHandler is the handler for proxying the calendar.
func ProxyHandler(w http.ResponseWriter, r *http.Request) {
	calendarURL := os.Getenv(calendarURLEnv)
	if calendarURL == "" {
		http.Error(w, fmt.Sprintf("Error: %s environment variable not set", calendarURLEnv), http.StatusInternalServerError)
		return
	}

	resp, err := http.Get(calendarURL)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error fetching calendar from %s: %s", calendarURL, err), http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error reading calendar response: %s", err), http.StatusInternalServerError)
		return
	}

	// Clean the calendar data
	cleanedBody := strings.TrimPrefix(string(body), "<pre>")
	cleanedBody = strings.TrimSuffix(cleanedBody, "</pre>")

	// Set the correct content type
	w.Header().Set("Content-Type", "text/calendar")

	// Serve the cleaned data
	if _, err := w.Write([]byte(cleanedBody)); err != nil {
		// It's often too late to send an HTTP error if writing the body fails,
		// but we can log it.
		fmt.Printf("Error writing response: %s\n", err)
	}
}


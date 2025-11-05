package main

import (
	"net/http"
)

func (app *application) routes() *http.ServeMux {
	// native http.ServeMux cannot handle custom error messages. For this, use httprouter. Will require changes in logic to extract parameter values.
	mux := http.NewServeMux()

	mux.HandleFunc("GET /v1/healthcheck", app.healthCheckHandler)
	mux.HandleFunc("GET /v1/quotes/{id}", app.showQuoteHandler)
	mux.HandleFunc("POST /v1/quotes", app.createQuoteHandler)

	return mux
}

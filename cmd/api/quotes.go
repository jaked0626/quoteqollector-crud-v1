package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/jaked0626/quoteqollector-crud-v1/internal/models"
)

func (app *application) createQuoteHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "create a new quote")
}

func (app *application) showQuoteHandler(w http.ResponseWriter, r *http.Request) {
	id, err := app.readIDParam(r)
	if err != nil {
		app.notFoundResponse(w, r)
		return
	}

	quote := models.Quote{
		ID:            id,
		Type:          "quote",
		Body:          "In a world gone topsy turvy, the truth is a moment of falsehood.",
		WorkID:        0,
		ContributorID: 0,
		CreatedAt:     time.Now(),
	}

	err = app.writeJSON(w, http.StatusOK, envelope{"quote": quote}, nil)
	if err != nil {
		app.logger.Println(err)
		app.serverErrorResponse(w, r, err)
	}

	// fmt.Fprintf(w, "get quote with id : %d\n", id)
}

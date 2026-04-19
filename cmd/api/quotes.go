package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/jaked0626/quoteqollector-crud-v1/internal/models"
	"github.com/jaked0626/quoteqollector-crud-v1/internal/validator"
)

func (app *application) createQuoteHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "create a new quote")
	var input struct {
		Type          string `json:"type"`
		Body          string `json:"body"`
		WorkID        int64  `json:"work_id"`
		ContributorID int64  `json:"contributor_id"`
	}

	err := app.readJSON(w, r, &input)
	if err != nil {
		app.errorResponse(w, r, http.StatusBadRequest, err.Error())
		return
	}

	v := validator.New()
	v.Check(input.Type != "", "type", "must be provided and nonempty")
	v.Check(input.Type == "quote" || input.Type == "note", "type", "must be either 'quote' or 'note'")
	v.Check(input.Body != "", "body", "must be provided and nonempty")

	if !v.Valid() {
		app.failedValidationResponse(w, r, v.Errors)
		return
	}

	fmt.Fprintf(w, "%+v\n", input)
}

func (app *application) showQuoteHandler(w http.ResponseWriter, r *http.Request) {
	id, err := app.readIDParam(r)
	if err != nil {
		app.notFoundResponse(w, r)
		return
	}

	quote := models.Quote{
		ID:        id,
		Type:      "quote",
		Body:      "In a world gone topsy turvy, the truth is a moment of falsehood.",
		CreatedAt: time.Now(),
	}

	err = app.writeJSON(w, http.StatusOK, envelope{"quote": quote}, nil)
	if err != nil {
		app.logger.Println(err)
		app.serverErrorResponse(w, r, err)
	}

	// fmt.Fprintf(w, "get quote with id : %d\n", id)
}

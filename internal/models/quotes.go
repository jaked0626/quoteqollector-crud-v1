package models

import (
	"time"
)

type Quote struct {
	ID            int64     `json:"id"`
	Type          string    `json:"type"`
	Body          string    `json:"body"`
	WorkID        int64     `json:"work_id,omitempty"`
	ContributorID int64     `json:"contributor_id,omitempty"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"-"`
	DeletedAt     time.Time `json:"-"`
}

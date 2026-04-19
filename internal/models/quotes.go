package models

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID          uuid.UUID  `json:"id"`
	Name        string     `json:"name"`
	Email       string     `json:"email"`
	Birth       *time.Time `json:"birth"`
	Description *time.Time `json:"description"`
	ProfileURI  string     `json:"profile_uri"`

	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
	DeletedAt *time.Time `json:"deleted_at"`
}

type Author struct {
	ID          uuid.UUID  `json:"id"`
	Name        string     `json:"name"`
	Birth       *time.Time `json:"birth"`
	Death       *time.Time `json:"death"`
	Description string     `json:"description"`
	ProfileURI  string     `json:"profile_uri"`
	User        *User      `json:"user"`

	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
	DeletedAt *time.Time `json:"deleted_at"`
}

type Tag struct {
	ID    uuid.UUID `json:"id"`
	Value string    `json:"value"`
}

type Work struct {
	ID            uuid.UUID `json:"id"`
	Title         string    `json:"title"`
	YearPublished int       `json:"year_published"`
	Description   string    `json:"description"`
	CoverURI      string    `json:"cover_uri,omitempty"`
	Authors       []Author  `json:"authors,omitempty"`
	Tags          []Tag     `json:"tags,omitempty"`

	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
	DeletedAt *time.Time `json:"deleted_at"`
}

type Quote struct {
	ID            int64    `json:"id"`
	Type          string   `json:"type"`
	Body          string   `json:"body"`
	Work          *Work    `json:"work,omitempty"`
	Contributor   User     `json:"contributor,omitempty"`
	Authors       []Author `json:"authors,omitempty"`
	Tags          []Tag    `json:"tags,omitempty"`
	RelatedQuotes []Quote  `json:"related_quotes"`
	LikeCount     int64    `json:"like_count"`

	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"-"`
	DeletedAt time.Time `json:"-"`
}

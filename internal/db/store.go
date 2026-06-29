package db

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
)

// Store defines all functions to execute db queries, as well as transactions.
type Store interface {
	Querier

	// TODO: add transactions here.
}

// SQLStore implements interface (repository pattern). If we ever need to switch
// databases, we implement another Store that satisfies the above interface.
type SQLStore struct {
	connPool *pgxpool.Pool
	*Queries
}

func (store *SQLStore) execTx(ctx context.Context, fn func(*Queries) error) error {
	tx, err := store.connPool.Begin(ctx)
	if err != nil {
		return err
	}

	qtx := New(tx)
	err = fn(qtx)
	if err != nil {
		if rbErr := tx.Rollback(ctx); rbErr != nil {
			return fmt.Errorf("transaction error: %v; rollback error: %v", err, rbErr)
		}

		return err
	}

	return tx.Commit(ctx)
}

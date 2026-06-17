package db

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
)

// base repository for postgres repositories. Defines how to handle transactions.
type BaseRepository struct {
	connPool *pgxpool.Pool
	q        *Queries
}

func (r *BaseRepository) execTx(ctx context.Context, fn func(*Queries) error) error {
	tx, err := r.connPool.Begin(ctx)
	if err != nil {
		return err
	}

	q := New(tx)
	err = fn(q)
	if err != nil {
		if rbErr := tx.Rollback(ctx); rbErr != nil {
			return fmt.Errorf("transaction error: %v; rollback error: %v", err, rbErr)
		}

		return err
	}

	return tx.Commit(ctx)
}

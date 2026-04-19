-- name: GetQuoteByID :one
SELECT *
FROM quotes
WHERE id = sqlc.arg(quote_id)
LIMIT 1;

-- name: ListRecentQuotes :many
SELECT * 
FROM quotes
ORDER BY created_at DESC
LIMIT $1
OFFSET $2;

-- name: CreateQuote :exec
INSERT INTO quotes (
  body,
  type,
  work_id,
  contributor_id
) VALUES (
  sqlc.arg(quote_body),
  sqlc.narg(quote_type),
  sqlc.narg(work_id),
  sqlc.narg(user_id)
);

-- name: ListUserPostedQuotes :many
SELECT *
FROM quotes 
WHERE contributor_id = sqlc.arg(user_id);

-- name: ListUserSavedQuotes :many
SELECT * 
FROM quotes
WHERE
  quotes.id IN (
    SELECT user_quotes.quote_id 
    FROM user_quotes
    WHERE user_quotes.user_id = sqlc.arg(user_id)
  )
LIMIT 50;

-- name: GetQuoteTags :many
SELECT 
  t.id,
  t.value
FROM 
  tags t
LEFT JOIN 
  quote_tags qt ON qt.tag_id = t.id
WHERE qt.quote_id = sqlc.arg(quote_id);

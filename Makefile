include .env

.PHONY: serve
serve:
	- go run ./cmd/api

CONTAINER_NAME := qq_container

.PHONY: up
up:
	- docker compose --env-file .env -f infra/docker/docker-compose.yml up -d

.PHONY: down
down: 
	- docker compose -f infra/docker/docker-compose.yml down

.PHONY: connect-container
connect-container:
	- docker exec -it ${CONTAINER_NAME} sh

.PHONY: connect-db-superuser
connect-db-superuser:
	- docker exec -it ${CONTAINER_NAME} psql -U ${POSTGRES_USER}

.PHONY: connect-db-appuser
connect-db-appuser:
	- docker exec -it ${CONTAINER_NAME} psql ${APP_DB} -U ${APP_USER} 

.PHONY: migrateinit
migrateinit:
	- migrate create -ext sql -dir internal/postgres/migrations -seq init_schema

.PHONY: migrateup
migrateup:
	- migrate -path internal/postgres/migrations/ -database "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable" -verbose up

.PHONY: migratedown
migratedown:
	- migrate -path internal/postgres/migrations/ -database "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable" -verbose down

.PHONY: stop_container
stop_container:
	- docker stop ${CONTAINER_NAME}

.PHONY: clean_container
clean_container:
	- docker stop ${CONTAINER_NAME} && docker rm -v ${CONTAINER_NAME}

.PHONY: postgres_genqueries
postgres_genqueries:
	- sqlc generate -f ./internal/postgres/sqlc.yaml

.PHONY: main_build
main_build:
	- docker build -t gathergo_backend:latest . -f ./docker/main/Dockerfile

.PHONY: main_run
main_run:
	@echo "Starting gathergo_backend Docker container with env file: $(ENV_FILE)"
	@if [ -z "$(ENV_FILE)" ]; then echo "Please specify ENV_FILE, e.g., 'make run ENV_FILE=./.env'"; exit 1; fi
	@docker run --name gathergo_backend -p 8080:8080 --env-file $(ENV_FILE) \
	gathergo_backend:latest

.PHONY: main_clean
main_clean: 
	- docker stop gathergo_backend && docker rm -v gathergo_backend

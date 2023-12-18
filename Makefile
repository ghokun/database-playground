.PHONY: psql
psql:
	psql postgresql://postgres@localhost:9998/postgres

.PHONY: reset
reset:
	docker compose down
	docker compose up -d

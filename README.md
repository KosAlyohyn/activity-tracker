# activity-tracker

Rails API for activity tracking. Backend configuration and credentials are
documented in [backend/README.md](backend/README.md).

### Start development

Install Docker with Docker Compose support and start the Docker engine. Obtain
`backend/config/credentials/development.key` securely as described in the
[credentials instructions](backend/README.md#credentials).

Run these commands from the repository root:

```sh
docker compose build api
docker compose run --rm api bin/rails db:prepare
docker compose up -d
```

The API is available at [localhost:3000](http://localhost:3000). Check its health:

```sh
docker compose ps
curl --fail http://localhost:3000/up
```

The `api` service waits for the `db` health check before starting. Backend source
is mounted from `./backend` into `/app`, so local code changes are available in
the container. Rebuild the API image after changing gem dependencies.

### Common commands

```sh
# Follow API logs
docker compose logs -f api

# Open the Rails console
docker compose exec api bin/rails console

# Apply database migrations
docker compose exec api bin/rails db:prepare

# Prepare the test database and run tests
docker compose exec -e RAILS_ENV=test api bin/rails db:prepare test

# Stop the environment and retain database data
docker compose down
```

### Database

The API connects to PostgreSQL at `db:5432` on the Compose network. The database
port is not published to the host. Database data persists in the `postgres_data`
Docker volume mounted at `/var/lib/postgresql`.

The database name is `activity_tracker_development`. Compose supplies
`DATABASE_HOST`, `DATABASE_USERNAME`, and `DATABASE_PASSWORD` to the API. The
credentials in `compose.yaml` are for local development only.

`docker compose down -v` removes the database volume and its data.

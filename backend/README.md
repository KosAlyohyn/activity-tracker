# Backend

Rails API with PostgreSQL, Solid Queue for background jobs, and Solid Cache for
database-backed caching. Mail, WebSocket, file upload, and rich text frameworks are
not loaded. The CORS initializer is retained for frontend integration.

## Docker development

Use the root [development guide](../README.md#start-development) to build and start
the API and PostgreSQL with Docker Compose. Run Compose commands from `backend/`
and initialize `.env` from `.env.example` before starting. The development image
is defined in `Dockerfile.dev` and uses Ruby 4.0.7; application source is mounted
into `/app`.

`GET /api/v1/health` returns HTTP `200` with `{"status":"ok"}`. The Rails `/up`
endpoint remains available. Tests use RSpec; see the root
[common commands](../README.md#common-commands) for running them in Docker.

## Credentials

Credentials are separate for each Rails environment:

| Environment | Encrypted file (commit to Git) | Key (local only) |
| --- | --- | --- |
| Development | `config/credentials/development.yml.enc` | `config/credentials/development.key` |
| Test | `config/credentials/test.yml.enc` | `config/credentials/test.key` |
| Production | `config/credentials/production.yml.enc` | `config/credentials/production.key` |

Rails selects these files automatically based on `RAILS_ENV`. Each encrypted file
contains its own `secret_key_base`; credentials are not shared between environments.
The old shared `config/credentials.yml.enc` and `config/master.key` are no longer used.

Run commands from `backend/` to edit credentials:

```sh
EDITOR="vi" bin/rails credentials:edit --environment development
EDITOR="vi" bin/rails credentials:edit --environment test
EDITOR="vi" bin/rails credentials:edit --environment production
```

On a new checkout, obtain the keys securely and save them to the paths above with
file permissions `600`. All `config/credentials/*.key` files are ignored by Git.
Keep a backup of the keys in a password manager; encrypted files cannot be recovered
without their matching keys. Use test credentials without real service secrets.

Alternatively, set `RAILS_MASTER_KEY` to the key for the current environment. This
variable takes precedence over local key files, so do not globally export one key
for all environments. In CI, provide the test key through the CI secret store.

Kamal reads `config/credentials/production.key` on the deployment machine and passes
it to the application as `RAILS_MASTER_KEY`. Only the encrypted production file is
committed to Git. Password manager integration for deployment can replace the local
file lookup later.

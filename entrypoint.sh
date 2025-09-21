#!/usr/bin/env sh
set -e

# Run DB migrations (needs DATABASE_URL available at runtime)
cd /app/packages/db
bunx drizzle-kit migrate --config=./drizzle.config.ts

# Start the Next.js server from apps/sim
cd /app/apps/sim
exec bun run start -- --port "${PORT:-3000}"

# Bun image for build + runtime
FROM oven/bun:1

WORKDIR /app
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    HOSTNAME=0.0.0.0 \
    PORT=3000

# Ensure `bunx` exists (repo runs it in scripts)
RUN ln -sf "$(command -v bun)" /usr/local/bin/bunx || true

# Copy everything (we’ll rely on .dockerignore to keep the context small)
COPY . .

# Install deps (try frozen lock if present; otherwise normal install)
RUN (test -f bun.lockb && bun install --frozen-lockfile) || bun install

# Build the app (turborepo root builds apps/sim)
RUN bun run build

# Entrypoint will run migrations then start the server
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000
CMD ["/entrypoint.sh"]

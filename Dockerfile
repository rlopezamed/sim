# --- Single-image approach with Bun for build + runtime ---
FROM oven/bun:1

WORKDIR /app
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    HOSTNAME=0.0.0.0 \
    PORT=3000

# Biome is executed via `bunx` in prebuild; make sure bunx exists
RUN ln -sf "$(command -v bun)" /usr/local/bin/bunx || true

# Install deps
COPY bun.lockb package.json ./
COPY . .
RUN bun install --frozen-lockfile

# Build the app (turborepo root will build apps/sim)
RUN bun run build

# Copy an entrypoint that runs DB migrations, then starts the app
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000
CMD ["/entrypoint.sh"]

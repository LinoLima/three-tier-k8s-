# ============================================================
# frontend/Dockerfile
# ============================================================


# ── Stage 1: deps ────────────────────────────────────────────
# Install all dependencies in an isolated stage.
# This layer is cached aggressively — it only reruns when package.json or pnpm-lock.yaml changes.
FROM node:20-alpine AS deps

# Install pnpm globally
RUN npm install -g pnpm

WORKDIR /app

# Copy only package files — not the source code.
# If source changes but packages don't, Docker uses the cache node_modules from a previous build (faster CI/CD builds).
COPY package.json pnpm-lock.yaml ./

# Install all dependencies including devDependencies.
# Next.js build tools (next, typescript, tailwind) are dev deps.
RUN pnpm install --frozen-lockfile


# ── Stage 2: builder ─────────────────────────────────────────
# Compile the Next.js app into production static and server files.
# Output goes into /app/.next,  this is what gets served at runtime.
FROM node:20-alpine AS builder

RUN npm install -g pnpm

WORKDIR /app

# Pull in the node_modules installed in deps.
# This avoids running pnpm install twice.
COPY --from=deps /app/node_modules ./node_modules

# Copy all source code AFTER copying node_modules.
COPY . .

# Build the Next.js app for prod.
RUN pnpm run build


# ── Stage 3: runtime ─────────────────────────────────────────
# Minimal production image, only the compiled output and the node_modules needed to run next start.
FROM node:20-alpine AS runtime

# Create a non-root user for security.
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001

WORKDIR /app

# Copy the compiled Next.js output from the builder stage.
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next

# Copy the public folder, static files served directly (images, fonts).
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

# Copy node_modules, needed at runtime because Next.js server imports React, MUI, and other packages when handling requests.
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules

# Copy package.json, Next.js reads it for project config at startup.
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json

# Copy next.config.ts, contains runtime configuration like environment variables, headers, redirects, emotion compiler, etc.
COPY --from=builder --chown=nextjs:nodejs /app/next.config.ts ./next.config.ts

# Switch to non-root user, all followed commands run as nextjs.
USER nextjs

# Document that the app listens on port 3000.
EXPOSE 3000

# Set production environment — disables Next.js dev warnings and enables production optimizations like response caching.
ENV NODE_ENV=production
ENV PORT=3000

# Health check, hits the homepage every 30s.
# 20s startup grace period to allow Next.js server to initialize.
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD wget -qO- http://localhost:3000/ || exit 1

# Start the Next.js production server.
# Calling the next binary directly from node_modules instead of using pnpm run start, avoids an extra pnpm process so Node.js is PID 1 and receives Docker/K8s shutdown signals correctly.
CMD ["node_modules/.bin/next", "start"]

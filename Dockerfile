# Stage 1: Development/Build Stage
FROM node:18-bullseye AS builder

WORKDIR /app

# --- REMOVED THE APK ADD LINE ---

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production Stage
FROM node:18-bullseye AS runner

WORKDIR /app

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000
CMD ["node", "server.js"]

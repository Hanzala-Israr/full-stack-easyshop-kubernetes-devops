# --- Production Runtime Stage ---
FROM node:18-bullseye-slim AS runner

# Set working directory
WORKDIR /app

# Ensure we are explicitly running inside production constraints
ENV NODE_ENV=production
ENV PORT=3000

# Copy over the entire workspace files (including pre-built modules and Next build artifacts)
COPY . .

# Expose app routing port
EXPOSE 3000

# Start up the standard engine wrapper
CMD ["npx", "next", "start"]

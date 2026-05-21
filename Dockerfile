# Use Node.js 18 Bullseye as a stable runtime base
FROM node:18-bullseye-slim
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# 1. Directly copy the pre-built node_modules from the host
COPY migration_modules ./node_modules

# 2. Directly copy the compiled production build folder from the host
COPY .next ./.next
COPY public ./public
COPY package*.json ./

EXPOSE 3000

# Run the production server directly using the local binary
CMD ["node_modules/.bin/next", "start"]

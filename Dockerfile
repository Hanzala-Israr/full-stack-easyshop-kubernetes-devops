# Use Node.js 18 Bullseye as a stable runtime base
FROM node:18-bullseye-slim
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# 1. Directly copy the unignored dependency layer
COPY migration_modules ./node_modules

# 2. Directly copy the unignored production build folder into the expected path
COPY migration_next ./.next
COPY public ./public
COPY package*.json ./

EXPOSE 3000

# Run the production server directly using the local binary
CMD ["node_modules/.bin/next", "start"]

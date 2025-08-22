# Use Node.js 18 alpine image for development
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Copy package files first (for better Docker layer caching)
COPY package*.json ./

# Install ALL dependencies (including dev dependencies for development)
RUN npm install

# Copy source code
COPY . .

# Build the application for development
RUN npm run build

# Expose port 4173 (Vite preview default port)
EXPOSE 4173

# Use development server with preview mode (built files but with dev setup)
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "4173"]

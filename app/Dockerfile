FROM node:20-alpine

WORKDIR /app

# Copy deps first for better layer caching
COPY package.json .
RUN npm install --production

COPY src/ ./src/

EXPOSE 3000

USER node

CMD ["node", "src/index.js"]

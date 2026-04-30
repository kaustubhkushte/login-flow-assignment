FROM node:20-alpine

WORKDIR /app

COPY package.json package.json
RUN npm install

COPY index.html index.html
COPY src ./src
COPY public ./public
COPY vite.config.js vite.config.js

EXPOSE 5173

CMD ["npm", "run", "dev"]

FROM node:18-alpine

WORKDIR /app

RUN npm install -g truffle

COPY package*.json ./
RUN npm install

COPY . .

CMD ["./deploy_and_sync.sh"]

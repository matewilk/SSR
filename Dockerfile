FROM node:12.0.0

COPY . /app
WORKDIR /app

RUN npm install

EXPOSE 5000

CMD ["npm", "run", "dev"]

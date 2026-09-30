FROM node:18-alpine

WORKDIR /app

# Copia manifesto e instala apenas dependências de produção
COPY package*.json ./
RUN npm ci --only=production

# Copia o código-fonte
COPY src/ ./src/

# Roda como usuário não-root (node está disponível no node:18-alpine)
USER node

EXPOSE 3000

CMD ["node", "src/index.js"]

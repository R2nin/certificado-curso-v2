FROM node:20-alpine

# curl para o healthcheck do nó local
RUN apk add --no-cache curl

WORKDIR /app

# Copia manifests primeiro — aproveita cache de layers do Docker
COPY package*.json ./
RUN npm ci

# Copia o restante do código-fonte
COPY . .

# Usa o compilador solc-js instalado via npm.
# Evita download externo de binários em tempo de build (mais reproduzível).
ENV SOLC_LOCAL=1

# Compila o contrato na hora do build da imagem
RUN npx hardhat compile

# Padrão: roda a suite de testes
CMD ["npx", "hardhat", "test"]

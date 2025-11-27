 
# Utiliser Node Alpine pour image légère
FROM node:22-alpine

# Créer le répertoire de travail
WORKDIR /app

# Copier uniquement package.json et package-lock.json pour utiliser le cache Docker
COPY src/package*.json ./

# Installer les dépendances de production seulement
RUN npm install --production && npm cache clean --force

# Copier le reste du code
COPY src/ ./

# Créer un utilisateur non-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app
USER nodejs

# Exposer le port de l'application
EXPOSE 3000

# Healthcheck simple
HEALTHCHECK --interval=30s --timeout=3s \
    CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode===200?0:1))"

# Lancer le serveur
CMD ["node", "server.js"]

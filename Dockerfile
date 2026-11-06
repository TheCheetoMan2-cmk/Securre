# Keep this text file beside SecureBrowser_Render.zip.
# Render Dockerfile Path: ./Dockerfile
# Render Docker Build Context: .
FROM python:3.13-slim AS unpack
WORKDIR /source
COPY SecureBrowser_Render.zip /tmp/source.zip
RUN python -m zipfile -e /tmp/source.zip /source

FROM node:24-bookworm-slim
ENV NODE_ENV=production
ENV PORT=10000
WORKDIR /app
COPY --from=unpack /source/package.json /source/package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
COPY --from=unpack /source/*.js ./
COPY --from=unpack /source/secure-index.json ./
COPY --from=unpack /source/public/ ./public/
USER node
EXPOSE 10000
CMD ["node", "server.js"]

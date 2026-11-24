# Etapa 1: clonar el repositorio e instalar/compilar Angular.
FROM node:22-alpine AS build

RUN apk add --no-cache git

ARG REPO_URL
ARG REPO_BRANCH=main
RUN test -n "$REPO_URL" || (echo "Falta definir REPO_URL con la URL pública del repositorio GitHub" && exit 1) \
    && git clone --depth 1 --branch "$REPO_BRANCH" "$REPO_URL" /workspace

WORKDIR /workspace/my-app
RUN npm install \
    && npm run build
RUN if [ -d dist/my-app/browser ]; then \
      cp -a dist/my-app/browser /tmp/angular-site; \
    elif [ -d dist/my-app ]; then \
      cp -a dist/my-app /tmp/angular-site; \
    else \
      echo "No se encontró la salida de Angular en dist/my-app/browser ni dist/my-app"; exit 1; \
    fi

# Etapa 2: servir los archivos estáticos con Nginx.
FROM nginx:alpine AS production

# Angular application builder genera los estáticos en browser/ cuando usa SSR.
# El segundo caso contempla proyectos que generan directamente en dist/my-app.
COPY --from=build /tmp/angular-site/ /usr/share/nginx/html/

# Fallback de rutas para aplicaciones Angular tipo SPA.
RUN printf '%s\n' \
    'server {' \
    '    listen 80;' \
    '    server_name _;' \
    '    root /usr/share/nginx/html;' \
    '    index index.html;' \
    '    location / {' \
    '        try_files $uri $uri/ /index.html;' \
    '    }' \
    '}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

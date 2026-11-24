# Actividad 9: Docker Compose — Equipo 6

Esta práctica construye una imagen multi-stage: la primera etapa clona el repositorio público, instala las dependencias y compila la aplicación Angular de `my-app`; la segunda sirve los archivos generados con Nginx Alpine. El puerto local `8080` se publica como el puerto `80` del contenedor.

## Integrantes

- Harold Gamaliel Constante Cruz
- Jesus Adan Alvarez Ramirez
- Silvestre Chavez Martinez
- Jaime Torres Suarez
- Andres Javier Muñiz Aguirre

## Requisito previo

Instala y ejecuta Docker Desktop para Windows. El repositorio de la aplicación debe ser público y contener el proyecto Angular dentro de la carpeta `my-app`.

La URL configurada en `docker-compose.yml` es `https://github.com/Gamagood/equipocurso6` y la rama de compilación es `migracion-angular`. Esa rama debe estar publicada en GitHub y contener `my-app/package.json`. Si usas otro repositorio o rama, cambia `REPO_URL` o `REPO_BRANCH` en el mismo archivo.

El repositorio actualmente tiene `my-app` en la rama local `migracion-angular`, mientras que la rama predeterminada remota `main` no contiene ese proyecto. Antes de construir, confirma los cambios de la aplicación y publica la rama:

```powershell
git add README.md my-app
git commit -m "Preparar aplicación Angular para Docker"
git push -u origin migracion-angular
```

Si Git responde que no hay cambios para confirmar, continúa con el `git push`. No agregues `mi-practica-docker` a ese commit si piensas publicarla después en un repositorio distinto.

## Construir y levantar

Desde PowerShell, sitúate en esta carpeta y ejecuta:

```powershell
docker compose up --build -d
```

Abre [http://localhost:8080](http://localhost:8080) para comprobar la aplicación. Para consultar el estado y los registros:

```powershell
docker compose ps
docker compose logs -f angular-web
```

Detén el servicio cuando termines:

```powershell
docker compose down
```

## Exportar la imagen

Con la imagen construida, expórtala desde PowerShell:

```powershell
docker save -o imagen-equipo6.tar actividad9-equipo6:latest
```

El archivo `.tar` puede ocupar cientos de MB. GitHub bloquea archivos individuales mayores a 100 MB en Git normal; si supera ese límite, usa Git LFS (y ten en cuenta las cuotas de almacenamiento y transferencia de tu cuenta) o comparte la imagen por otro medio.

## Subir el proyecto a GitHub

Crea primero un repositorio vacío en GitHub, sin README, licencia ni `.gitignore`. Después, desde esta carpeta, inicializa Git, agrega todos los archivos incluida la imagen exportada y publica la rama principal:

```powershell
git init
git add .
git commit -m "Actividad 9: Docker Compose para Angular"
git branch -M main
git remote add origin https://github.com/USUARIO/NUEVO-REPOSITORIO.git
git push -u origin main
```

Reemplaza la URL del último comando con la URL HTTPS del nuevo repositorio. Si la imagen supera los 100 MB y tienes Git LFS instalado, ejecuta `git lfs install` y `git lfs track "*.tar"` antes de `git add .`; confirma también el archivo `.gitattributes` que crea LFS.

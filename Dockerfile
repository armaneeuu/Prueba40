# Etapa de construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copiar el archivo de proyecto y restaurar dependencias
COPY *.csproj ./
RUN dotnet restore

# Copiar el resto del código y publicar
COPY . ./
RUN dotnet publish -c Release -o out

# Etapa de producción
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Instalar dependencias necesarias para SkiaSharp y HarfBuzzSharp
RUN apt-get update && apt-get install -y \
    libharfbuzz0b \
    libfontconfig1 \
    libfreetype6 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxcb1 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxdamage1 \
    libxfixes3 \
    libcups2 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Copiar los archivos publicados desde la etapa de construcción
COPY --from=build-env /app/out .

# Definir el nombre del archivo DLL de tu aplicación
ENV APP_NET_CORE=Prueba40.dll

ENV ASPNETCORE_ENVIRONMENT=Development


# Comando para ejecutar la aplicación
CMD ["sh", "-c", "ASPNETCORE_URLS=http://*:$PORT dotnet $APP_NET_CORE"]

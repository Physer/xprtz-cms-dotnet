﻿FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Cms/Cms.csproj", "Cms/"]
RUN dotnet restore "Cms/Cms.csproj"
COPY . .
WORKDIR "/src/Cms"
RUN dotnet build "Cms.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "Cms.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# We need to make sure that the user running the app has write access to the umbraco folder, in order to write logs and other files.
# Since these are volumes they are created as root by the docker daemon.
USER root
RUN mkdir umbraco
RUN mkdir umbraco/Logs
RUN chown $APP_UID umbraco --recursive
USER $APP_UID
ENTRYPOINT ["dotnet", "Cms.dll"]
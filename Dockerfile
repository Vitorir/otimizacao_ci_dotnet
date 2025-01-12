FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
ARG CSPROJ
COPY . .
RUN dotnet restore "$CSPROJ" && \
    dotnet build "$CSPROJ" -c Release && \
    dotnet publish "$CSPROJ" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
RUN groupadd -g 1000 appgroup && \
    useradd -m -u 1000 -g appgroup appuser
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyWorker.dll"]
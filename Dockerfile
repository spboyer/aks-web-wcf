FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY aks-web-wcf.csproj .
RUN dotnet restore -nowarn:msb3202,nu1503
COPY . .
RUN dotnet build aks-web-wcf.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish aks-web-wcf.csproj -c Release -o /app

FROM base AS final

# install nodejs for JavaScript Services
RUN apt-get update
RUN apt-get -f install -my wget gnupg
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

COPY --from=publish /app .
ENTRYPOINT ["dotnet", "aks-web-wcf.dll"]

FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY aks-web-wcf.sln ./
COPY aks-web-wcf.csproj
RUN dotnet restore -nowarn:msb3202,nu1503
COPY . .
WORKDIR /src/
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final

# install nodejs for angular
RUN apt-get update  
RUN apt-get -f install  
RUN apt-get install -y wget  
RUN wget -qO- https://deb.nodesource.com/setup_8.x | bash -  
RUN apt-get install -y build-essential nodejs

WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "aks-web-wcf.dll"]

docker build -t my-webapp:latest ./webapp

docker swarm init

docker stack deploy -c docker-compose.swarm.yml myapp


docker stack services myapp
docker stack ps myapp
docker service logs myapp_api

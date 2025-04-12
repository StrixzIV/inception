DOTENV_PATH=""
DOCKER_COMPOSE_PATH=""

all: start

start:
	@echo "Starting docker-compose"
	docker-compose --env-file $(DOTENV_PATH) -f $(DOCKER_COMPOSE_PATH) up
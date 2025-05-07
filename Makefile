DOTENV_PATH=""
DOCKER_COMPOSE_PATH=""

all: start

setup:
	@mkdir -p data/wordpress data/mariadb
	@chmod +x ./srcs/requirements/tools/generate_secrets.sh
	@bash ./srcs/requirements/tools/generate_secrets.sh

start:
	@echo "Starting docker-compose"
	docker-compose --env-file $(DOTENV_PATH) -f $(DOCKER_COMPOSE_PATH) up
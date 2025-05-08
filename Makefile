VOLUMES_DIRS = data/wordpress data/mariadb

all: setup up

setup:
	@mkdir -p $(VOLUMES_DIRS)
	@chmod +x ./srcs/requirements/tools/generate_secrets.sh
	@bash ./srcs/requirements/tools/generate_secrets.sh

up:
	@echo "Starting docker-compose..."
	@docker-compose --env-file ./srcs/.env -f ./srcs/docker-compose.yml up -d --build

down:
	@echo "Stopping docker-compose..."
	@docker-compose -f ./srcs/docker-compose.yml down

prune:
	@echo "Pruning..."
	@docker system prune -a

list:
	@echo "Current docker processes:"
	@docker ps -a
	@echo
	@echo "Current docker volumes:"
	@docker volume ls

fclean: down prune
	@echo "Cleaning..."
	@rm -rf secrets/ssl
	@docker stop $(docker ps -qa) 2>/dev/null || true
	@docker rm $(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $(docker images -qa) 2>/dev/null || true
	@docker volume rm $(docker volume ls -q) 2>/dev/null || true
	@docker network rm $(docker network ls -q) 2>/dev/null || true

re: down up

.PHONY: setup up down prune list fclean re

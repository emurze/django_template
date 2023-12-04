# Variables

DEFAULT_COLOR=\e[0m

BLUE=\e[34m

YELLOW=\033[33m

DOCKER_CONTAINER_NAME={project_name}

DOCKER_NAME_LINE=$(echo "{project_name}" | tr '[:graph:]' '-')


# Run

run:
	docker compose up -d --build

run-prod:
	docker compose -f docker-compose.prod.yml up -d --build


# Migrations

migrations:
	@if [ -z $$(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		echo "${YELLOW}Error docker container ${DOCKER_CONTAINER_NAME} does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		exit 1; \
	else \
		docker exec ${DOCKER_CONTAINER_NAME} bash -c "cd src && poetry run python3 manage.py makemigrations"; \
	fi

migrate:
	@if [ -z $$(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		echo "${YELLOW}Error docker container ${DOCKER_CONTAINER_NAME} does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		exit 1; \
	else \
		docker exec ${DOCKER_CONTAINER_NAME} bash -c "cd src && poetry run python3 manage.py migrate"; \
	fi


# Stop

down:
	docker compose down
	docker compose -f docker-compose.prod.yml down

clean:
	docker compose down -v
	docker compose -f docker-compose.prod.yml down -v

# Tests | You can run tests only if you have previously run container

lint:
	@if [ -z $$(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		echo "${YELLOW}Error docker container ${DOCKER_CONTAINER_NAME} does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		exit 1; \
	else \
		poetry run flake8 --config setup.cfg src tests; \
	fi

unittests:
	@if [ -z $$(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		echo "${YELLOW}Error docker container ${DOCKER_CONTAINER_NAME} does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		exit 1; \
	else \
		docker exec ${DOCKER_CONTAINER_NAME} poetry run python3 -m unittest discover src/utils/; \
	fi

coverage:
	@if [ -z $$(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		echo "${YELLOW}Error docker container ${DOCKER_CONTAINER_NAME} does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		exit 1; \
	else \
		docker exec ${DOCKER_CONTAINER_NAME} bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test && poetry run coverage report --rcfile ../setup.cfg --data-file logs/.coverage"; \
	fi

e2etests:
	@if [ -z $$(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		echo "${YELLOW}Error docker container ${DOCKER_CONTAINER_NAME} does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n----------------------------------------------------${DOCKER_NAME_LINE}\n"; \
		exit 1; \
	else \
		docker exec ${DOCKER_CONTAINER_NAME} bash -c "poetry run python3 src/manage.py test tests"; \
	fi

test: lint coverage e2etests

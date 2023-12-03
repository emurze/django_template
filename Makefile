# Colors
DEFAULT_COLOR=\e[0m
BLUE=\e[34m
YELLOW=\e[33m

DOCKER_CONTAINER_NAME=e-learning

# Run

run:
	docker compose up -d --build

run_prod:
	docker compose -f docker-compose.prod.yml up -d --build

# Tests | You can run tests only if you have previously run container

lint:
	poetry run flake8 --config setup.cfg src tests

unittests:
	@if [ -z $$(docker ps -q -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		echo "\n-------------------------------------------------------------\n"; \
        echo "${YELLOW}Error Docker container $(DOCKER_CONTAINER_NAME) does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n-------------------------------------------------------------\n"; \
		exit 1; \
    else \
        docker exec e-learning poetry run python3 -m unittest discover src/utils/; \
    fi

coverage:
	@if [ -z $$(docker ps -q -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
        echo "\n-------------------------------------------------------------\n"; \
        echo "${YELLOW}Error docker container $(DOCKER_CONTAINER_NAME) does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n-------------------------------------------------------------\n"; \
		exit 1; \
    else \
        docker exec e-learning bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test && poetry run coverage report --rcfile ../setup.cfg --data-file logs/.coverage"; \
    fi

e2etests:
	@if [ -z $$(docker ps -q -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		echo "\n-------------------------------------------------------------\n"; \
        echo "${YELLOW}Error docker container $(DOCKER_CONTAINER_NAME) does not exist. Use ${BLUE}make run${DEFAULT_COLOR}"; \
		echo "\n-------------------------------------------------------------\n"; \
		exit 1; \
    else \
        docker exec e-learning bash -c "poetry run python3 src/manage.py test tests"; \
    fi

test: lint coverage e2etests

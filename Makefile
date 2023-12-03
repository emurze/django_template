# Run

run:
	docker compose up --build

run_prod:
	docker compose -f docker-compose.prod.yml up --build

# Tests | You can run tests only if you have previously run container

lint:
	poetry run flake8 --config setup.cfg src tests

unittests:
	docker exec {project_name} poetry run python3 -m unittest discover src/utils/

coverage:
	docker exec {project_name} bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test && poetry run coverage report --rcfile ../setup.cfg --data-file logs/.coverage"

e2etests:
	docker exec {project_name} bash -c "poetry run python3 src/manage.py test tests"

test:
	make lint
	make coverage
	make e2etests

# Run

run:
	docker compose up --build

run_prod:
	docker compose -f docker-compose.prod.yml up --build

# Tests | You can run tests only if you have previously run container

lint:
	poetry run flake8 --config setup.cfg src tests

unittests:
	docker exec e-learning poetry run python3 -m unittest discover src/utils/

coverage:
	docker exec e-learning bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test && poetry run coverage report --rcfile ../setup.cfg --data-file logs/.coverage"

e2etests:
	docker exec e-learning bash -c "poetry run python3 src/manage.py test tests"

test: lint coverage e2etests

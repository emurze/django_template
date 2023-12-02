
UNIT_TESTS:
	docker exec -it <project_name> poetry run python3 -m unittest discover src/utils/

COVERAGE:
	docker exec -it <project_name> bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test && poetry run coverage report --rcfile ../setup.cfg --data-file logs/.coverage"

E2E_TESTS:
	docker exec -it <project_name> bash -c "poetry run python3 src/manage.py test tests"

FLAKE8:
	flake8 --config setup.cfg src

TEST:
	make FLAKE8
	make COVERAGE
	make E2E_TESTS

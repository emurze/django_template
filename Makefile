
unittests:
	docker exec -it <project_name> poetry run python3 -m unittest discover src/utils/

coverage:
	docker exec -it <project_name> bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test && poetry run coverage report --rcfile ../setup.cfg --data-file logs/.coverage"

e2etests:
	docker exec -it <project_name> bash -c "poetry run python3 src/manage.py test tests"

lint:
	poetry run flake8 --config setup.cfg src tests

test:
	make lint
	make coverage
	make e2etests

commit:
	echo "run test"
	echo "git commit"

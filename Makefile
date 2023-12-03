# Run

run:
	docker compose up --build

run_prod:
	docker compose -f docker-compose.prod.yml up --build

# Tests | You can run tests only if you have previously run container

lint:
	poetry run flake8 --config setup.cfg src tests

unittests:
	if [[ $(docker ps | grep {project_name}) ]] 
	then 
		docker exec e-learning poetry run python3 -m unittest discover src/utils/
	else
		echo "Please run your docker containers"
		exit 1
	fi

coverage:
	if [[ $(docker ps | grep {project_name}) ]] 
	then 
		docker exec e-learning bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test && poetry run coverage report --rcfile ../setup.cfg --data-file logs/.coverage"
	else
		echo "Please run your docker containers"
		exit 1
	fi

e2etests:
	if [[ $(docker ps | grep {project_name}) ]] 
	then 
		docker exec e-learning bash -c "poetry run python3 src/manage.py test tests"
	else
		echo "Please run your docker containers"
		exit 1
	fi

test: lint coverage e2etests

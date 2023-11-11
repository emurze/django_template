# Django Template

## How install project?

```
git clone git@github.com:emurze/django_template.git
```

```
mv django_template/ <project_name>
```

```
cd <project_name>
```

```
bash setup.sh <project_name>
```


## How run project?

Run dev server

```
docker compose up --build
```

Run prod server

```
docker compose -f docker-compose.prod.yml up --build
```


## How run tests?

Coverage
```
docker exec -it blog bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test && poetry run coverage report --data-file logs/.coverage"
```

Unittests
```
docker exec -it blog bash -c "cd src && poetry run python3 manage.py test apps"
```

End-To-End
```
docker exec -it blog bash -c "cd src && poetry run python3 manage.py test functional_tests"
```

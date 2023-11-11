# Django Template

# How install project?

* ```git clone git@github.com:emurze/django_template.git```

  
* ```mv django_template/ <project_name>```


* ```cd <project_name>```


* ```bash setup.sh <project_name>```

# How run tests?

Coverage
```
docker exec -it blog bash -c "cd src && poetry run coverage run --rcfile ../setup.cfg manage.py test && poetry run coverage report"
```

Unittests
```
docker exec -it blog bash -c "cd src && poetry run python3 manage.py test apps"
```

End-To-End
```
docker exec -it blog bash -c "cd src && poetry run python3 manage.py test functional_tests"
```

# How run project?

Run dev server in background

```docker compose up --build -d```

Run prod server in background

```docker compose -f docker-compose.prod.yml up --build -d```


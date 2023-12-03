# Django Template

## You should have

- SECRET_KEY
- DOCKER_USERNAME
- DOCKER_PASSWORD

## How to install project?

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
bash setup.sh <project_name> <docker_username>
```

## How to setup env?

Cenv/<project_name>.env:
  - SECRET_KEY

Git repository add:
  - SECRET_KEY
  - DOCKER_PASSWORD

## How to run project?

Run dev server

DOCKER_USERNAME

```
docker compose up --build
```

Run prod server

```
docker compose -f docker-compose.prod.yml up --build
```


## How to run tests?

Unittests
```
make unittests
```

End-To-End
```
make e2etests
```

Total Testing
```
make test
```

# Django Template

## Generate SECRET_KEY

```
pip install Django==4
```

```
python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

## Requirements

- PROJECT_NAME

- SECRET_KEY

- DOCKER_USERNAME

- DOCKER_PASSWORD

## You should setup git repository secrets

- SECRET_KEY

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
bash setup.sh "<project_name>" "<secret_key>" "<docker_username>"
```

## How to run project?

Run dev server

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

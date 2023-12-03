# Django Template

## How to setup github repository?

1. Create new repository

2. Click Settings

3. Security -> Secrets and variables -> Actions

4. Generate SECRET_KEY
    ```
    pip install Django==4 && python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
    ```
5. Add secrets

  - SECRET_KEY

  - DOCKER_PASSWORD


## How to install project?

```
git clone git@github.com:emurze/django_template.git
```
#####
```
mv django_template/ <project_name>
```
#####
```
cd <project_name>
```

```
bash setup.sh "<project_name>" "<secret_key>" "<docker_username>" "<github_username>"
```

## How to run project?

Run dev server

```
make run
```

Run prod server

```
make run-prod
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

## How to run migrations7

```
make migrations
```

```
make migrate
```

## How to clean project7

Drop containers
```
make down
```

Drop containers and volumes
```
make clean
```

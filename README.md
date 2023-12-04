# Django Template

## How to setup github repository?

1. Create new repository

2. Click Settings -> Security -> Secrets and variables -> Actions

3. Generate SECRET_KEY like ```sb+3xjvr&37u7#$s6)xmzs+%0at_ze792q(wop$znwpwrk556$```
    ```
    pip install Django==4 && python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
    ```
   
4. Add secrets

  - SECRET_KEY

  - DOCKER_PASSWORD

5. Install and push project

6. Click Settings -> Branches -> Add branch protection rule

    - type ```master```
      
    - Add Require a pull request before merging - Require approvals + Dismiss stale pull request approvals when new commits are pushed
    
    - Require status checks to pass before merging + Add lint, unit-integraton-tests, build, end-to-end-tests
    
    - Do not allow bypassing the above settings

## How to install project?

```
git clone git@github.com:emurze/django_template.git
```

<!-- ##### -->
```
mv django_template/ <project_name>
```
<!-- ##### -->

```
cd <project_name>
```

```
bash setup.sh <project_name> "<secret_key>" <docker_username> <github_username>
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

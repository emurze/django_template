# Django Template

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
bash setup.sh <project_name>
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

Lint
```
make LINT
```

Coverage
```
make COVERAGE
```

Unittests
```
make UNIT_TESTS
```

End-To-End
```
make E2E_TESTS
```

Total Testing
```
make TEST
```

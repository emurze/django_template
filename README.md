# Django Template

# How install project?

* git clone git@github.com:emurze/django_template.git
* mv django_template <project_name>
* cd <project_name>

# Remove traces

```rm -rf .git```

# How run project?

***You must be in the root dir***

Create /env/.db.env and /env/.<project_name>.env

```mkdir env && > env/.db.env && > env/.<project_name>.env```

Fill env/.db.env and env/.<project_name>.env

For example: 

*env/.<project_name>.env*

```
# APP
SECRET_KEY=django-insecure-@l8=fm$s+-mjm-2i0)uoly9j+2pctx@+^k27(g$(bqw%i%jk-$
DEBUG=1
LOGGING_LEVEL=DEBUG

# DB
DB_NAME=optimization_app
DB_USER=optimization_app
DB_PASSWORD=12345678
DB_HOST=db
DB_POST=5432
```

*env/.db.env*
```
# POSTGRES
POSTGRES_DB=optimization_app
POSTGRES_USER=optimization_app
POSTGRES_PASSWORD=12345678
```

Change <project_name> in the docker-compose.yml and the docker-compose.dev.yml

Create logs dir and general.log file

```mkdir src/logs && > src/logs/general.log ```

Run dev server

```docker compose up --build```

Run prod server

```docker compose -f docker-compose.prod.yml up --build```

# How create venv to future development?

```poety init```

```poetry config virtualenvs.path .```

```poetry install```

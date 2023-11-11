set -e

# Setup project


# Remove traces

rm -rf .git


# Setup project name

RED='\033[0;31m'

if [[ -z $1 ]]; then
  echo -e "${RED}Please enter the project_name"
  exit 1
else
  project_name=$1
fi


sed -i "s/{project_name}/${project_name}/g" nginx/default.conf

sed -i "s/{project_name}/${project_name}/g" docker-compose.yml

sed -i "s/{project_name}/${project_name}/g" docker-compose.prod.yml


# Setup env

poetry init

poetry config virtualenvs.in-project true

poetry add django~=4.2.6 \
           Pillow~=10.0.1 \
           psycopg2-binary~=2.9.9 \
           gunicorn~=21.2.0 \
           coverage~=7.3.2

poetry install

# Create functional tests dir

mkdir src/functional_tests
touch src/functional_tests/__init__.py


# Create env

if ! test -f env; then
    mkdir env 2> out.txt
fi

echo '''
# POSTGRES
POSTGRES_DB={project_name}
POSTGRES_USER={project_name}
POSTGRES_PASSWORD=12345678
''' > "env/.db.env"

echo '''
# APP
SECRET_KEY=django-insecure-@l8=fm$s+-mjm-2i0)uoly9j+2pctx@+^k27(g$(bqw%i%jk-$
DEBUG=1
LOGGING_LEVEL=DEBUG

# DB
DB_NAME={project_name}
DB_USER={project_name}
DB_PASSWORD=12345678
DB_HOST=db
DB_POST=5432

# ADMIN
DEFAULT_ADMIN_NAME=adm1
DEFAULT_ADMIN_EMAIL=adm1@adm1.com
DEFAULT_ADMIN_PASSWORD=adm1
''' > "env/.${project_name}.env"

sed -i "s/{project_name}/${project_name}/g" "env/.db.env"

sed -i "s/{project_name}/${project_name}/g" "env/.${project_name}.env"


# Create logs

mkdir src/logs 2> out.txt

touch src/logs/general.log 2> out.txt

echo 
'''
# Django Template

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
''' > README.md

# Remove traces

rm -rf out.txt

rm -rf setup.sh

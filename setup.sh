#!/bin/sh
set -e

# Setup project

# .git/
#     hooks/
#         pre-commit
# .github/
#     workflows/
#        main.yml
# .venv/
# env/
#    .${project_name}.env
#    .db.env
#
# setup.sh - deleted


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

if [[ -z $2 ]]; then
  echo -e "${RED}Please enter the secret_key"
  exit 1
else
  secret_key=$2
fi

if [[ -z $3 ]]; then
  echo -e "${RED}Please enter the docker_username"
  exit 1
else
  docker_username=$2
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
           coverage~=7.3.2 \
           selenium~=4.15.2 \
           flake8~=6.1.0

poetry install --no-root

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
SECRET_KEY={secret_key}
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


sed -i "s/{secret_key}/${secret_key}/g" "env/.${project_name}.env"


# Create .github/workflows/main.yml

mkdir .github/ 2> out.txt
mkdir .github/workflows/ 2> out.txt
touch .github/workflows/main.yml 2> out.txt

echo '''
name: Django CI

on: [push]

env:
  STAGING_SERVER: localhost

  DEBUG: 1
  LOGGING_LEVEL: DEBUG

  DB_NAME: {project_name}
  DB_USER: {project_name}
  DB_PASSWORD: 12345678

  POSTGRES_DB: {project_name}
  POSTGRES_USER: {project_name}
  POSTGRES_PASSWORD: 12345678

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Set up Repository
        uses: actions/checkout@v4

      - name: Install Python 3.11
        uses: actions/setup-python@v4
        with:
          python-version: 3.11

      - name: Install flake8
        run: |
          pip install flake8

      - name: Lint with flake8
        run: |
          flake8 --config setup.cfg src tests

  unit-integration-tests:
    needs: lint
    runs-on: ubuntu-latest
    services:
      db:
        image: postgres:13.0-alpine
        ports:
          - 5432:5432
        env:
          POSTGRES_DB: {project_name}
          POSTGRES_USER: {project_name}
          POSTGRES_PASSWORD: 12345678
    steps:
      - name: Set up Repository
        uses: actions/checkout@v4

      - name: Create Log File
        run: |
          mkdir src/logs && touch src/logs/general.log

      - name: Install Python 3.11
        uses: actions/setup-python@v4
        with:
          python-version: 3.11

      - name: Install Poetry
        run: |
          pip install poetry==1.7.1
          poetry config virtualenvs.create true
          poetry config virtualenvs.in-project true

      - name: Install Dependencies
        run: |
          poetry install

      - name: Run Unit and Integration Tests
        run: |
          bash -c "cd src &&
                   poetry run coverage run --rcfile ../setup.cfg --data-file logs/.coverage manage.py test &&
                   poetry run coverage report --rcfile ../setup.cfg --data-file logs/.coverage"

  build:
    needs: unit-integration-tests
    runs-on: ubuntu-latest
    steps:
    - name: Set up Repository
      uses: actions/checkout@v4

    - name: Login to Docker Hub
      uses: docker/login-action@f4ef78c080cd8ba55a85445d5b36e214a81df20a
      with:
        username: {docker_username}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and push Docker image
      uses: docker/build-push-action@3b5e8027fcad23fda98b2e3ac259d8d67585f671
      with:
        context: .
        file: ./dockerfile
        push: true
        tags: {docker_username}/{project_name}:1

  end-to-end-tests:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Set up Repository
        uses: actions/checkout@v4

      - name: Create Log File
        run: |
          mkdir src/logs && touch src/logs/general.log

      - name: Create Env dir
        run: |
          mkdir env

      - uses: KengoTODA/actions-setup-docker-compose@v1
        with:
          version: 2.14.2

      - name: Run production server
        run: |
          echo "SECRET_KEY=${{ secrets.SECRET_KEY }}" >> env/.{project_name}.env
          echo "DEBUG=$DEBUG" >> env/.{project_name}.env
          echo "LOGGING_LEVEL=$LOGGING_LEVEL" >> env/.{project_name}.env
          echo "DB_NAME=$DB_NAME" >> env/.{project_name}.env
          echo "DB_USER=$DB_USER" >> env/.{project_name}.env
          echo "DB_HOST=db" >> env/.{project_name}.env
          echo "DB_PASSWORD=$DB_PASSWORD" >> env/.{project_name}.env
          echo "STAGING_SERVER=$STAGING_SERVER" >> env/.{project_name}.env

          echo "POSTGRES_DB=$POSTGRES_DB" >> env/.db.env
          echo "POSTGRES_USER=$POSTGRES_USER" >> env/.db.env
          echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> env/.db.env
          
          docker compose -f docker-compose.prod.yml up -d

      - name: Install Python 3.11
        uses: actions/setup-python@v4
        with:
          python-version: 3.11

      - name: Install Poetry
        run: |
          pip install poetry==1.7.1
          poetry config virtualenvs.create true
          poetry config virtualenvs.in-project true

      - name: Install Dependencies
        run: |
          poetry install

      - name: Run End-To-End tests
        run: |
          poetry run python3 src/manage.py test tests
''' > .github/workflows/main.yml

sed -i "s/{project_name}/${project_name}/g" ".github/workflows/main.yml"

sed -i "s/{docker_username}/${docker_username}/g" ".github/workflows/main.yml"

# Create logs

mkdir src/logs 2> out.txt

touch src/logs/general.log 2> out.txt

# Create README.md

echo '''
# Project <project_name>

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
''' > README.md

sed -i "s/<project_name>/${project_name}/g" README.md

# Fill MakeFile

sed -i "s/{project_name}/${project_name}/g" Makefile

# Remove traces

rm -rf out.txt

rm -rf setup.sh

# Create git hook

git init

touch .git/hooks/pre-commit

chmod +x .git/hooks/pre-commit

echo '''
#!/bin/sh
make test
''' > .git/hooks/pre-commit



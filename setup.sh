#!/bin/sh

set -e


# Colors

DEFAULT_COLOR="\e[0m"
BLUE="\033[34m"
YELLOW="\033[33m"


# Remove traces

rm -rf .git


# Check arguments

if [[ -z $1 ]]; then
    echo -e "\n---------------------------------------------------------------------\n";
    echo -e "${YELLOW}Please enter the <project_name> <secret_key> <docker_username>${DEFAULT_COLOR}";
    echo -e "\n---------------------------------------------------------------------\n";
    exit 1;
else
    project_name=$1
fi

if [[ -z $2 ]]; then
    echo -e "\n-------------------------------------------------------------\n";
    echo -e "${YELLOW}Please enter the <secret_key> <docker_username>${DEFAULT_COLOR}";
    echo -e "\n-------------------------------------------------------------\n";
    exit 1;
else
    secret_key=$2
fi

if [[ -z $3 ]]; then
    echo -e "\n-------------------------------------------------------------\n";
    echo -e "${YELLOW}Please enter the <docker_username>${DEFAULT_COLOR}";
    echo -e "\n-------------------------------------------------------------\n";
    exit 1;
else
    docker_username=$3
fi


# Fill nginx, docker-compose, docker-compose.prod

sed -i "s/{project_name}/${project_name}/g" nginx/default.conf

sed -i "s/{project_name}/${project_name}/g" docker-compose.yml

sed -i "s/{project_name}/${project_name}/g" docker-compose.prod.yml


# Setup venv

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

mv .github/workflows/main.yml.sample .github/workflows/main.yml

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

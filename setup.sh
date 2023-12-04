#!/bin/sh

set -e


# Remove traces

rm -rf .git


# Colors

DEFAULT_COLOR="\e[0m"

BLUE="\033[34m"

YELLOW="\033[33m"


# Check arguments

if [[ -z $1 ]]; then
    echo -e "\n------------------------------------------------------------------------------------------\n";
    echo -e "${YELLOW}Please enter the arguments <project_name> <secret_key> <docker_username> <github_username>${DEFAULT_COLOR}";
    echo -e "\n------------------------------------------------------------------------------------------\n";
    exit 1;
else
    project_name=$1
fi

if [[ $1 == "<project_name>" ]]; then 
    echo -e "\n----------------------------------------\n";
    echo -e "${YELLOW}Please enter the <project_name> argument${DEFAULT_COLOR}";
    echo -e "\n----------------------------------------\n";
    exit 1;
fi

if [[ -z $2 ]]; then
    echo -e "\n---------------------------------------------------------------------------\n";
    echo -e "${YELLOW}Please enter the arguments <secret_key> <docker_username> <github_username>${DEFAULT_COLOR}";
    echo -e "\n---------------------------------------------------------------------------\n";
    exit 1;
else
    secret_key=$2
fi

if [[ $2 == "<secret_key>" ]]; then 
    echo -e "\n--------------------------------------\n";
    echo -e "${YELLOW}Please enter the <secret_key> argument${DEFAULT_COLOR}";
    echo -e "\n--------------------------------------\n";
    exit 1;
fi

if [[ -z $3 ]]; then
    echo -e "\n--------------------------------------------------------------\n";
    echo -e "${YELLOW}Please enter the arguments <docker_username> <github_username>${DEFAULT_COLOR}";
    echo -e "\n--------------------------------------------------------------\n";
    exit 1;
else
    docker_username=$3
fi

if [[ $3 == "<docker_username>" ]]; then 
    echo -e "\n-------------------------------------------\n";
    echo -e "${YELLOW}Please enter the <docker_username> argument${DEFAULT_COLOR}";
    echo -e "\n-------------------------------------------\n";
    exit 1;
fi

if [[ -z $4 ]]; then
    echo -e "\n-------------------------------------------\n";
    echo -e "${YELLOW}Please enter the <github_username> argument${DEFAULT_COLOR}";
    echo -e "\n-------------------------------------------\n";
    exit 1;
else
    github_username=$4
fi

if [[ $4 == "<github_username>" ]]; then 
    echo -e "\n-------------------------------------------\n";
    echo -e "${YELLOW}Please enter the <github_username> argument${DEFAULT_COLOR}";
    echo -e "\n-------------------------------------------\n";
    exit 1;
fi


# Fill nginx, docker-compose, docker-compose.prod, Makefile

sed -i "s/{project_name}/${project_name}/g" nginx/default.conf

sed -i "s/{project_name}/${project_name}/g" docker-compose.yml

sed -i "s/{project_name}/${project_name}/g" docker-compose.prod.yml

sed -i "s/{project_name}/${project_name}/g" Makefile


# Create .github/workflows/main.yml

mv .github/workflows/main.yml.sample .github/workflows/main.yml

sed -i "s/{project_name}/${project_name}/g" ".github/workflows/main.yml"

sed -i "s/{docker_username}/${docker_username}/g" ".github/workflows/main.yml"


# Update README.md

sed -i "s/emurze/${github_username}/g" README.md

sed -i 's/bash setup.sh <project_name> "<secret_key>" <docker_username> <github_username>/bash setup.sh "<secret_key>"/g' README.md

sed -i "s/<project_name>/${project_name}/g" README.md

sed -i "s/Django Template/Project ${project_name}/g" README.md

sed -i "s/django_template/${project_name}/g" README.md

sed -i '/<!-- ##### -->/,/<!-- ##### -->/d' README.md


# Create git hook

git init

touch .git/hooks/pre-commit

chmod +x .git/hooks/pre-commit

echo '''
#!/bin/sh
make test
''' > .git/hooks/pre-commit


# Setup pyporject.toml, poetry.lock

poetry init

poetry config virtualenvs.in-project true

poetry add django~=4.2.6 \
           Pillow~=10.0.1 \
           psycopg2-binary~=2.9.9 \
           gunicorn~=21.2.0 \
           coverage~=7.3.2 \
           selenium~=4.15.2 \
           flake8~=6.1.0
           

# Recreate setup.sh

rm -rf setup.sh

echo '''#!/bin/sh

set -e


# Colors

DEFAULT_COLOR="\e[0m"

BLUE="\033[34m"

YELLOW="\033[33m"


# Check arguments

if [[ -z $1 ]]; then
    echo -e "\n--------------------------------------\n";
    echo -e "${YELLOW}Please enter the <secret_key> argument${DEFAULT_COLOR}";
    echo -e "\n--------------------------------------\n";
    exit 1;
else
    secret_key=$1
fi

if [[ $1 == "<secret_key>" ]]; then 
    echo -e "\n--------------------------------------\n";
    echo -e "${YELLOW}Please enter the <secret_key> argument${DEFAULT_COLOR}";
    echo -e "\n--------------------------------------\n";
    exit 1;
fi


# Setup logs

mkdir -p src/logs

touch src/logs/general.log 2> out.txt


# Setup venv

poetry install --no-root


# Setup env

mkdir -p env

echo """
# POSTGRES
POSTGRES_DB={project_name}
POSTGRES_USER={project_name}
POSTGRES_PASSWORD=12345678
""" > env/.db.env

echo """
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
""" > env/.{project_name}.env

sed -i "s/{secret_key}/${secret_key}/g" env/.{project_name}.env

rm -rf out.txt
''' > setup.sh

sed -i "s/{project_name}/${project_name}/g" setup.sh


# Setup venv, env, logs

bash setup.sh ${secret_key}

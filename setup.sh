# Setup project


# Remove traces

rm -rf .git

# Setup project name

project_name=tdd


sed -i "s/{new_project}/${project_name}/g" docker-compose.yml
sed -i "s/{new_project}/${project_name}/g" docker-compose.prod.yml


# Setup env

poetry init

poetry config virtualenvs.path .

poetry add django~=4.2.6 \
           Pillow~=10.0.1 \
           psycopg2-binary~=2.9.9 \
           gunicorn~=21.2.0

poetry install


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
''' > "env/.${project_name}.env"

sed -i "s/{project_name}/${project_name}/g" "env/.db.env"
sed -i "s/{project_name}/${project_name}/g" "env/.${project_name}.env"


# Create logs

mkdir src/logs && > src/logs/general.log

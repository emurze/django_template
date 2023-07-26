set -e

cd src

python3 manage.py migrate --no-input

python3 manage.py createadmin --username adm1 --password adm1

python3 manage.py runserver 0.0.0.0:8080

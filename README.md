# PROJECT TEMPLATE

# How run project?

Create /env/.db.env and /env/.online_shop.env

```mkdir env && > env/.db.env && > env/.online_shop.env```

Fill env/.db.env and env/.online_shop.env

For example: 

*env/.online_shop.env*

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

Create logs dir and general.log file

```mkdir src/logs && > src/logs/general.log ```

Run project

```docker compose up --build```

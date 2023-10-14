FROM python:3.11

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONNUNBUFFERED 1

WORKDIR /service/

COPY poetry.lock .
COPY pyproject.toml .
RUN pip3 install poetry
RUN poetry install

COPY src src

EXPOSE 8080
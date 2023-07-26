FROM python:3.11

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONNUNBUFFERED 1

WORKDIR /usr/django_project

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .

EXPOSE 8080
CMD ["bash", "runserver.sh"]
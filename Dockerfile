FROM python:3-alpine AS builder

RUN apk add --update make cmake gcc g++ gfortran
RUN pip install cython

ENV PYTHONUNBUFFERED 1
ENV APP_DIR /code
WORKDIR $APP_DIR

COPY requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir

FROM builder as started

COPY ./tools/startup.py .
CMD python startup.py

FROM started as naive_bayes
COPY ./naive_bayes/nb_author_id.py .
RUN g++ -o /binary source.cpp
CMD python nb_author_id.py
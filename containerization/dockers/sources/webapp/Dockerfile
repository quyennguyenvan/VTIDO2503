ARG IMAGE_BASE=3.11.13-bullseye
FROM python:${IMAGE_BASE}

RUN apt-get update && apt-get -y install libpq-dev gcc 
WORKDIR /app
COPY ./requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

EXPOSE 5000

RUN useradd appuser 
USER appuser
COPY . /app
ENTRYPOINT [ "python3" ]
CMD [ "main.py" ]
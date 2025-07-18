ARG IMAGE_BASE=3.11.13-bullseye
FROM python:${IMAGE_BASE}

RUN apt-get update && apt-get -y install libpq-dev gcc 
ENV SET_MY_NAME=joe
ARG APP_VERSION=1.0
RUN echo "build app with ${APP_VERSION}"
WORKDIR /app
COPY ./requirements.txt requirements.txt
# ADD https://getsamplefiles.com/download/ogg/sample-1.ogg  sample-1.ogg
RUN pip3 install -r requirements.txt

EXPOSE 5000

RUN useradd appuser 
USER appuser
COPY . /app
ENTRYPOINT [ "python3" ]
CMD [ "main.py" ]
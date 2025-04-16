FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y python3-pip mysql-client && \
    apt-get clean

WORKDIR /app

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8080

ENTRYPOINT ["python3"]
CMD ["app.py"]
FROM python:3.11-slim  

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-distutils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /data


COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY . .


RUN python manage.py migrate --noinput

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

FROM python:3.13-slim

# Install system dependencies including distutils
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-distutils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies first (better layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Run migrations (skip if no database configured)
RUN python manage.py migrate --noinput

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

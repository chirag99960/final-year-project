FROM python:3.11-slim  # Changed to 3.11 to match Debian's Python version

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-distutils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /data

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Database setup (only works if DATABASE_URL is provided)
RUN python manage.py migrate --noinput

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Use a slim Python image to reduce the attack surface
FROM python:3.12-slim

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set a working directory
WORKDIR /app

# Create non-root user FIRST
RUN useradd -m appuser

# Copy requirements first to leverage Docker layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Create directories for data and static files, then collect static files.
# This is critical: Nginx needs these files to be present at /app/staticfiles.
RUN mkdir -p /app/data /app/staticfiles && chown -R appuser:appuser /app/data /app/staticfiles

# Switch to non-root user for security
USER appuser

# Expose the port Gunicorn will listen on
EXPOSE 8000

# Start Gunicorn
CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:8000", "config.wsgi:application"]
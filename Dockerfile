FROM python:3.12-slim

# System Dependencies setup
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy all project files
COPY . .

# Upgrade pip and install modern build backends (hatchling)
RUN pip install --no-cache-dir --upgrade pip setuptools wheel hatchling build

# Install FastAPI, server dependencies, and Strix package
RUN pip install --no-cache-dir fastapi uvicorn playwright pydantic requests
RUN pip install --no-cache-dir --no-build-isolation . || pip install --no-cache-dir -e .

# Install Playwright browser binaries
RUN playwright install --with-deps chromium

EXPOSE 8000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
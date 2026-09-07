FROM python:3.11-slim

# System Dependencies + Playwright Browsers setup
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy repo content first
COPY . .

# Install dependencies directly
RUN pip install --no-cache-dir fastapi uvicorn playwright
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi
RUN if [ -f pyproject.toml ]; then pip install --no-cache-dir .; fi
RUN playwright install --with-deps chromium

EXPOSE 8000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
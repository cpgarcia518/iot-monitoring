# Stage 1: Build
FROM python:3.9-slim as builder

WORKDIR /app

# Install dependencies first (cached unless requirements change)
COPY services/video-api/requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2: Runtime
FROM python:3.9-slim

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /root/.local /root/.local
COPY services/video-api/app ./app

# Ensure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Use the project's root .env file (mounted in compose.yaml)
ENV PYTHONUNBUFFERED=1

# Run as non-root user
RUN useradd -m appuser && chown -R appuser /app
USER appuser

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
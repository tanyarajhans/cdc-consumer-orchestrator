FROM --platform=linux/arm64 python:3.9-slim
RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY main.py .
CMD ["python",  "-u", "main.py"]

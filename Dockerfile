FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ ./src/
COPY tests/ ./tests/

FROM python:3.12-slim AS runner
WORKDIR /app

COPY --from=builder /usr/local/lib/python3.12/site-packages/ /usr/local/lib/python3.12/site-packages/

COPY --from=builder /app/src/ ./src/
COPY --from=builder /app/tests/ ./tests/

CMD ["pytest", "tests/", "-v"]
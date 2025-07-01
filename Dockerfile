FROM python:3.11-slim-bullseye

WORKDIR /app

# Среда
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Установи зависимости, если появятся в будущем
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем код
COPY bot /app/bot

CMD ["python", "-m", "bot"]
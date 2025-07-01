FROM python:3.11-slim-bullseye as compile-image
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
COPY requirements.txt .
RUN apt update &&  \
    apt install -y libtiff5-dev libjpeg62-turbo-dev libopenjp2-7-dev zlib1g-dev \
      libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk \
      libharfbuzz-dev libfribidi-dev libxcb1-dev &&  \
    pip install --no-cache -r /app/requirements.txt && \
    pip wheel --no-cache-dir --wheel-dir /opt/pip_wheels -r /app/requirements.txt

# Образ, который будет непосредственно превращаться в контейнер
FROM python:3.11-slim-bullseye as run-image
WORKDIR /app
COPY --from=compile-image /opt/pip_wheels /opt/pip_wheels
RUN pip install --no-cache /opt/pip_wheels/* && rm -rf /opt/pip_wheels
COPY bot /app/bot
CMD ["python", "-m", "bot"]
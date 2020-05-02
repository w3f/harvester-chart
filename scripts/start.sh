#! /usr/bin/env sh

if [ -z $ENVIRONMENT ] || [ "$ENVIRONMENT" = "dev" ]; then
    ENVIRONMENT="prod"
fi

echo "==========================="
echo "Environment: $ENVIRONMENT"
echo "==========================="

echo "Running gunicorn..."

if [ "$ENVIRONMENT" = "dev" ]; then
    gunicorn -b 0.0.0.0:8001 --workers=2 app.main:app --reload --chdir /usr/src/app
fi

if [ "$ENVIRONMENT" = "prod" ]; then
    # gunicorn config for Docker
    #gunicorn -b 0.0.0.0:8000 --workers=5 app.main:app --worker-class="egg:meinheld#gunicorn_worker"
    gunicorn -b 0.0.0.0:8000 --workers=2 app.main:app --threads 4 --worker-class=gthread --log-file=- --chdir /usr/src/app
fi

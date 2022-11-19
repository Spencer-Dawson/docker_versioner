#!/bin/sh
# Handles initialization including user creation then starts the versioner server
cd /opt/versioner

# migrate database
python manage.py migrate --noinput

# collect static files
python manage.py collectstatic --noinput

# create django admin user if it doesn't exist
if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_EMAIL" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
    echo "Creating Super User $DJANGO_SUPERUSER_USERNAME"
    python manage.py createsuperuser --noinput
fi

# make sure www-data can write to db.sqlite3
chown -R www-data:www-data /opt/versioner
chmod -R u+w /opt/versioner/

# start server
(gunicorn versioner.wsgi --user www-data --bind 0.0.0.0:8080 --workers 3) & nginx -g "daemon off;"

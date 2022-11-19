FROM python:3.7

# To set the djangoadmin user and password you can either pass in the following
# environment variables (insecure, but a common practice) using -e
# - DJANGO_SUPERUSER_USERNAME
# - DJANGO_SUPERUSER_EMAIL
# - DJANGO_SUPERUSER_PASSWORD
# or for a more secure way to set credentials you can shell into the running
# container and run
# 'python manage.py createsuperuser' from the /opt/versioner directory

# required ports
EXPOSE 80/tcp

# Persistent volume for the sqlite database
VOLUME /opt/versioner/db

# todo use a pinned release version instead of master
ARG VERSIONER_REPO=https://github.com/Spencer-Dawson/versioner.git
ARG VERSIONER_BRANCH=main

# Install system dependencies
RUN apt-get update && apt-get install \
    nginx \
    -y --no-install-recommends && rm -rf /var/lib/apt/lists/*
COPY nginx.default.conf /etc/nginx/sites-available/default

# Pull versioner from github and install it
RUN cd /opt && \
    git clone ${VERSIONER_REPO} && \
    cd versioner && \
    git checkout ${VERSIONER_BRANCH} && \
    pip install -r requirements.txt && \
    pip install gunicorn

COPY internalDeployment.settings.py /opt/versioner/versioner/settings.py
COPY start-server.sh /opt/versioner/start-server.sh
RUN chmod +x /opt/versioner/start-server.sh
RUN chown -R www-data:www-data /opt/versioner
RUN chmod -R u+w /opt/versioner/

# execute start-server.sh when container starts
CMD ["/opt/versioner/start-server.sh"]

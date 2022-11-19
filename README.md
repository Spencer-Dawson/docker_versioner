# Docker Versioner

## Description

Docker Versioner is a container build tool for Spencer-Dawson/versioner. For details about versioner see that projects repository.

## Quickstart
* 'docker run -p 80:80 -v /appdata/versioner:/opt/versioner/db -e DJANGO_SUPERUSER_USERNAME=yourusername -e DJANGO_SUPERUSER_PASSWORD=yourpassword -e DJANGO_SUPERUSER_EMAIL=admin@example.com spec4d/docker_versioner'

## Port Forwards
* Currently only tcp port 80 is intended to be exposed

## Volumes
* /opt/versioner/db is exported as a volume to enable persistant db storage across container updates

## Arguments
The container has three optional arguments to enable easy admin account creation.
Note: This is a common practice, but unsecure
* DJANGO_SUPERUSER_USERNAME
* DJANGO_SUPERUSER_PASSWORD
* DJANGO_SUPERUSER_EMAIL

Not supplying these arguments is fine, but that means you will have to shell into the container to run a command to set the admin credentials on first run
* 'python manage.py createsuperuser' from the /opt/versioner directory

## Building the image
* Pull the image from https://github.com/Spencer-Dawson/docker_versioner.git
* run a docker build

## Todo:
Here are some things I might get around to changing eventually
* Support HTTPS (Internal only tool so limited benefit)
* Use github actions to automatically update the public image
* Tie public images to release branches of Spencer-Dawson/versioner instead of main branch

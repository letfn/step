SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

build: # Build defn/step
	docker build -t defn/step .

push: # Push defn/step
	docker push defn/step

bash: # Run bash shell with defn/step
	docker run --rm -ti --entrypoint bash defn/step

clean:
	docker-compose down --remove-orphans

up:
	docker-compose up -d --remove-orphans

down:
	docker-compose rm -f -s

recreate:
	$(MAKE) clean
	$(MAKE) up

logs:
	docker-compose logs -f

renew: # Renew ssh key
	$(MAKE) recreate logs

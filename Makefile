SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

build: # Build defn/step, defn/step:cli
	docker build -t defn/step .
	docker build -t defn/step:cli b/step-cli

push: # Push defn/step, defn/step:cli
	docker push defn/step
	docker push defn/step:cli

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

user: # Renew user ssh cert
	pass step/pw > .step/.pw
	$(MAKE) recreate logs
	rm -f .step/.pw

host: # Generate an ssh host key
	pass step/pw > .step/.pw
	env COMPOSE_FILE=docker-compose-host.yml \
		$(MAKE) recreate logs
	rm -f .step/.pw

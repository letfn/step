SHELL := /bin/bash

menu:
	@perl -ne 'printf("%15s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

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

fingerprint: # Fingerprint of root cert
	step certificate fingerprint .step/certs/root_ca.crt

user: # Renew user ssh cert
	pass step/pw > ~/.password-store/step/.pw
	$(MAKE) recreate logs
	rm -f ~/.password-store/step/.pw

host: # Generate an ssh host key
	pass step/pw > ~/.password-store/step/.pw
	env COMPOSE_FILE=docker-compose-host.yml \
		$(MAKE) recreate logs
	rm -f ~/.password-store/step/.pw

bootstrap: # Bootstrap step client
	step ca bootstrap --ca-url "${caurl}" --fingerprint "${fingerprint}"

renew-host: # Renew ssh host cert
	cd /mnt/ssh && step ssh renew ssh_host_ecdsa_key-cert.pub ssh_host_ecdsa_key

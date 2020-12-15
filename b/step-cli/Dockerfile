FROM smallstep/step-cli:0.15.3

USER root

RUN apk add bash

COPY renew-user add-host /
RUN chmod 755 /renew-user /add-host

USER step

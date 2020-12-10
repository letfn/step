FROM smallstep/step-cli:0.15.3

USER root

RUN apk add bash

COPY renew /renew
RUN chmod 755 /renew

USER step

ENTRYPOINT [ "/renew" ]

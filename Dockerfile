FROM smallstep/step-ca:0.15.5

USER root

RUN apk add bash

USER step

COPY service /service

ENTRYPOINT [ "/service" ]

CMD [ "--password-file", ".step/.pw", ".step/config/ca.json" ]

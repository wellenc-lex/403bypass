FROM alpine:latest

COPY . .

RUN apk add --no-cache --upgrade grep

RUN chmod +x 403bypass.sh

#ENTRYPOINT ["automation.sh"]


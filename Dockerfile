FROM ubuntu:latest

COPY . .

RUN apt -y update && apt -y install dnsutils grep curl && rm -rf /var/lib/apt/lists/*

RUN chmod +x 403bypass.sh

#ENTRYPOINT ["automation.sh"]


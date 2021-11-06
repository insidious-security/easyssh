FROM debian:latest

COPY easyssh.sh /app/

ENTRYPOINT /app/easyssh.sh && /bin/bash

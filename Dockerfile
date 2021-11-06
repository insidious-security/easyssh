FROM debian:unstable-slim

COPY easyssh.sh /app/

ENTRYPOINT /app/easyssh.sh && /bin/bash

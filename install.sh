#!/bin/bash

printf "\n"
printf "Creating container..\n"
docker build -t easyssh . > /dev/null 2>&1
printf "Starting container, running config.\n"
docker run -dit --name easyssh -p 2107:22 easyssh:latest /bin/bash > /dev/null 2>&1
timeout 25s docker logs --follow easyssh 
printf "\n"


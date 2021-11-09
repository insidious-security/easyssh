#!/bin/bash

docker build -t easyssh . > /dev/null 2>&1
docker run -dit --name easyssh -p 2107:22 easyssh:latest /bin/bash > /dev/null 2>&1
timeout 40s docker logs --follow easyssh 



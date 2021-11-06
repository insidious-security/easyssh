echo "Creating container"
docker build -t easyssh . > /dev/null 2>&1
echo "Starting container, running config"
docker run -dit --name easyssh -p 2107:22 easyssh:latest /bin/bash > /dev/null 2>&1
docker logs --follow easyssh 


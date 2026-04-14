FROM rundeck/rundeck:5.4.0
USER root
RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*
USER rundeck

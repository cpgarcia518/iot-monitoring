# Copyright 2025 InfluxData
# Author: Carlos Alejandro Perez Garcia (cpgarcia518@gmail.com)

FROM telegraf:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    jq \
    mtr-tiny && \
    rm -rf /var/lib/apt/lists/*
	
# Copy configuration and scripts
COPY telegraf.conf /etc/telegraf/telegraf.conf
COPY scripts/ /opt/telegraf/scripts/

# Ensure scripts are executable
RUN chmod +x /opt/telegraf/scripts/*.sh
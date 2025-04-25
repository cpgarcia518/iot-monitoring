# Copyright 2025 InfluxData
# Author: Carlos Alejandro Perez Garcia (cpgarcia518@gmail.com)

FROM telegraf:latest

RUN apt-get update && apt-get install -y --no-install-recommends mtr-tiny && \
	rm -rf /var/lib/apt/lists/*

COPY telegraf.conf /etc/telegraf/telegraf.conf

# Copy the custom script
# COPY fetch_hobolink.sh /usr/local/bin/fetch_hobolink.sh
# RUN chmod +x /usr/local/bin/fetch_hobolink.sh
# Copyright 2025 InfluxData
# Author: Carlos Alejandro Perez Garcia (cpgarcia518@gmail.com)

FROM telegraf:latest

RUN apt-get update && apt-get install -y --no-install-recommends mtr-tiny && \
	rm -rf /var/lib/apt/lists/*

COPY telegraf.conf /etc/telegraf/telegraf.conf

# Copy the custom script
COPY scripts/hobolink_telegraf_fetcher.sh /opt/telegraf/scripts/hobolink_telegraf_fetcher.sh
RUN chmod +x /opt/telegraf/scripts/hobolink_telegraf_fetcher.sh
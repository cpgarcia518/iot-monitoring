# Copyright 2025 InfluxData
# Author: Carlos Alejandro Perez Garcia (cpgarcia518@gmail.com)

FROM telegraf:latest
LABEL maintainer="Carlos Alejandro Perez Garcia <cpgarcia518@gail.com>"

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    jq \
    mtr-tiny && \
    rm -rf /var/lib/apt/lists/*
	
# Create directory structure
# RUN mkdir -p /etc/telegraf/inputs.d /etc/telegraf/outputs.d /etc/telegraf/processors.d

# Copy configuration files
COPY telegraf.conf /etc/telegraf/telegraf.conf
COPY inputs.d/ /etc/telegraf/inputs.d/
COPY outputs.d/ /etc/telegraf/outputs.d/
# COPY processors.d/ /etc/telegraf/processors.d/
COPY scripts/ /opt/telegraf/scripts/
# Ensure all scripts are executable
RUN chmod +x /opt/telegraf/scripts/*.sh     

# Health check (optional)
# HEALTHCHECK --interval=30s --timeout=3s \
#   CMD telegraf --config /etc/telegraf/telegraf.conf --test >/dev/null 2>&1 || exit 1


# Run Telegraf with merged configurations
CMD ["telegraf", \
     "--config", "/etc/telegraf/telegraf.conf", \
     "--config-directory", "/etc/telegraf/inputs.d/", \
     "--config-directory", "/etc/telegraf/outputs.d/"]
    #  "--config-directory", "/etc/telegraf/processors.d/"]
# CMD ["telegraf", "--config", "/etc/telegraf/telegraf.conf"]
# CMD ["telegraf", "--config", "/etc/telegraf/telegraf.conf", "--once"]
# CMD ["telegraf", "--config", "/etc/telegraf/telegraf.conf", "--once", "--quiet"]
# CMD ["telegraf", "--config", "/etc/telegraf/telegraf.conf", "--once", "--quiet", "--debug"]
# CMD ["telegraf", "--config", "/etc/telegraf/telegraf.conf", "--once", "--quiet", "--debug", "--log-level=debug"]
# CMD ["telegraf", "--config", "/etc/telegraf/telegraf.conf", "--once", "--quiet", "--debug", "--log-level=debug", "--log-file=/var/log/telegraf.log"]
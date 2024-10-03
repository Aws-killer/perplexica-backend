# Use the official SearxNG image as the base
FROM docker.io/searxng/searxng:latest

# Switch to root user to adjust permissions
USER root
ENV DEFAULT_BIND_ADDRESS="0.0.0.0:7860"
ENV BIND_ADDRESS="${BIND_ADDRESS:-${DEFAULT_BIND_ADDRESS}}"

# Define directories to exclude from chmod
ENV EXCLUDE_DIRS="/dev /proc /sys /etc /run /var/lib/docker /var/run /usr /tmp /var/tmp /mnt /media"

# Apply chmod 777 recursively, excluding specified directories
RUN for DIR in $EXCLUDE_DIRS; do \
        echo "Excluding $DIR from chmod"; \
    done && \
    find / \
        $(printf "! -path %s/* " $EXCLUDE_DIRS) \
        -a ! $(printf "! -path %s" $EXCLUDE_DIRS | paste -sd " -o " -) \
        -exec chmod 777 {} \; || true
# RUN mkdir  /etc/searxng
COPY . .
RUN mkdir /etc/searxng
RUN chmod -R 777 /etc/searxng
# COPY settings.yml  /etc/searxng/settings.yml

# Expose the port that SearxNG listens on
EXPOSE 7860




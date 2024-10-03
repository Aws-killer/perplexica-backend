# Use the official Node.js slim image as the base
FROM node:slim

# Set environment variables for non-interactive installations
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory inside the container
WORKDIR /home/perplexica

# Install Git and other necessary packages
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Clone the repository into the working directory
RUN git clone https://github.com/ItzCrazyKns/Perplexica.git .

# Create the data directory with appropriate permissions
RUN chmod -R 777 /home/perplexica
COPY . .
# Modify the drizzle.config.ts to set the correct database path
# This assumes that the original filename is set to 'data/database.sqlite'
# Adjust the sed command if the original path is different
RUN sed -i "s|filename: '.*'|filename: '/home/perplexica/data/database.sqlite'|" drizzle.config.ts

# Install project dependencies using Yarn
RUN yarn install --frozen-lockfile

# Build the project
RUN yarn build

# Expose the application's port (adjust if different)
EXPOSE 7860

# Define the command to run the application
CMD bash create_config.sh && yarn start
# Chrome in Docker with Playwright

This project provides:

1. A Docker container with Chrome browser accessible via VNC and remote debugging
2. A TypeScript Playwright script that connects to the remote Chrome instance

## Setup

### Start the Docker container

```bash
# Build and start the container
docker-compose up -d

# Check if the container is running
docker-compose ps
```

### Install Node dependencies

```bash
npm install
```

## Running the Playwright script

Make sure the Docker container is running first, then:

```bash
npm start
```

The script will:
1. Connect to the Chrome browser running in Docker
2. Navigate to example.com
3. Take a screenshot
4. Go to Wikipedia and perform a search
5. Take another screenshot of the search results

## Accessing the Chrome browser directly

All services are accessible through a single port:

- VNC in browser: http://localhost:8080/
- Chrome remote debugging (for Playwright): http://localhost:8080/json

## Useful commands

```bash
# View container logs
docker-compose logs -f

# Stop the container
docker-compose down

# Rebuild and restart the container
docker-compose up -d --build
```
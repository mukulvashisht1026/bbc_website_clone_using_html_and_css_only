# bbc_website_clone_using_html_-_css_only

## Status and TODO

Static page: `make deploy` (Docker, http://localhost:8084), or open `bbc.html` directly.

- TODO: navigation and article links are static placeholders; there is no news data source.
this is a clone website of bbc news.it is based only on html and css only.

## Docker build and deployment

Run these commands from this repository's root. Requirements: Docker Engine or
Docker Desktop running, Docker Compose v2 with `--wait` support, and Make.
The first build needs internet access to download base images and dependencies.

### One-command build and run

```bash
make deploy
```

Open **http://localhost:8084**. This builds the image(s), starts containers in
the background, and waits for their health checks. Deployment targets your current
Docker context (normally your local machine); it does not create a cloud server.

```bash
make build      # Build without starting containers
make up         # Start previously built or loaded images
make status     # Show container health and ports
make logs       # Follow logs; Ctrl+C stops following logs
make stop       # Stop and remove this project's containers/network
```

Without Make, use `docker compose up -d --build --wait`.

### Port, architecture, and image name

```bash
make deploy PORT=9000
make deploy DOCKER_PLATFORM=linux/arm64
make deploy IMAGE_PREFIX=my-account IMAGE_TAG=v1
```

Default image: `mukul-local/bbc-clone:latest`. Default platform: `linux/amd64`.
Use `linux/arm64` for ARM servers or native Apple Silicon execution. Keep the same
platform, prefix, tag, and port overrides when running later Make commands.
The website listens on port 8080 inside its container.

### Copy images to another Docker server

After a successful build, export this project's image(s):

```bash
make export IMAGE_ARCHIVE=bbc-clone-images.tar
```

Copy `bbc-clone-images.tar`, `compose.yaml`, and `Makefile` into a directory on the
target server. Source code is unnecessary for running the loaded images:

```bash
make load IMAGE_ARCHIVE=bbc-clone-images.tar
make up
```

The server's CPU architecture must match the built images. Repeat any
`DOCKER_PLATFORM`, `IMAGE_PREFIX`, or `IMAGE_TAG` overrides used during the build.
To use a registry instead, tag and push the built image(s) to your registry, then
configure your container host to pull those tags. Registry publishing is manual.
For public HTTPS, configure a domain and TLS reverse proxy in your hosting platform.

### Application notes and verification

The image serves bbc.html as index.html, so the site opens at /. This is a static visual demo.

```bash
curl --fail http://localhost:8084/
```

Use the overridden port if you changed `PORT`. Check the app in a browser as well.

Docker builds and container runtime have not been verified in the preparation
environment because Docker daemon access was denied. Compose configuration and
Make command expansion are checked; a successful local build and health check
are still required.

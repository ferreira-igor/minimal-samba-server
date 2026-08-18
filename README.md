# Minimal Samba Server

[![Build](https://github.com/ferreira-igor/minimal-samba-server/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/ferreira-igor/minimal-samba-server/actions/workflows/docker-publish.yml)
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![GHCR](https://img.shields.io/badge/GHCR-Image-2496ED?logo=github&logoColor=white)](https://github.com/ferreira-igor/minimal-samba-server/pkgs/container/minimal-samba-server)
[![Platforms](https://img.shields.io/badge/platforms-amd64%20%7C%20arm64-2ea44f?logo=docker&logoColor=white)](https://github.com/ferreira-igor/minimal-samba-server)
[![License](https://img.shields.io/github/license/ferreira-igor/minimal-samba-server)](https://github.com/ferreira-igor/minimal-samba-server/blob/main/LICENSE)

A lightweight and secure Samba server for Docker with automatic user provisioning through environment variables.

Designed to be simple to deploy while following modern SMB security practices.

## Features

- 🚀 Based on Debian Slim
- 🔒 SMB2/SMB3 only
- 🔐 NTLMv2 authentication only
- 👤 Automatic user creation
- 👥 Unlimited users via environment variables
- 📁 Home directory shares
- ♻️ Recycle Bin support
- 🔑 Per-user permissions
- 🪶 Minimal image
- 🐳 Docker ready

---

## Running

Edit the `compose.yml` file:

```yaml
services:
  samba:
    image: ghcr.io/ferreira-igor/minimal-samba-server:main
    container_name: minimal-samba-server
    restart: unless-stopped
    ports:
      - 445:445
    volumes:
      - ./home:/home
    environment:
      SHARE_WORKGROUP: WORKGROUP

      USER_NAME_0: john
      USER_PASS_0: mySecurePassword

      USER_NAME_1: mary
      USER_PASS_1: anotherPassword

```

Start the container:

```bash
docker compose up -d
```
Or build it manually:

```bash
docker compose build
docker compose up -d
```

To stop the container:

```bash
docker compose down
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `SHARE_WORKGROUP` | Yes | Windows workgroup name |
| `USER_NAME_0` | Yes | First Samba username |
| `USER_PASS_0` | Yes | First Samba password |
| `USER_NAME_1` | No | Additional user |
| `USER_PASS_1` | No | Additional password |
| `USER_NAME_N` | No | Unlimited users supported |
| `USER_PASS_N` | No | Unlimited passwords supported |

---

## Security

This image ships with secure defaults:

- SMB2/SMB3 only
- NTLMv2 only
- Anonymous access disabled
- Private home directories (`0700`)
- Private files (`0600`)
- Per-user authentication
- Samba recycle bin enabled

---

## Directory Layout

```
/home
├── john
│   ├── Documents
│   └── Downloads
└── mary
    └── Pictures
```

Each user only has access to their own directory.

---

## How Users Work

Users are created automatically during container startup.

For example:

```text
USER_NAME_0=john
USER_PASS_0=password

USER_NAME_1=mary
USER_PASS_1=123456

USER_NAME_2=peter
USER_PASS_2=myPassword
```

There is no practical limit to the number of users.

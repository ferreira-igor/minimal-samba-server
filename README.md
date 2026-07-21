# Minimal Samba Server

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

Clone the repository:

```bash
git clone https://github.com/ferreira-igor/minimal-samba-server.git
cd minimal-samba-server
```

Edit the `compose.yml` file:

```yaml
services:
  samba:
    build: .
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

Build and start the container:

```bash
docker compose up -d --build
```

The `build: .` directive tells Docker Compose to build the image using the `Dockerfile` located in the current directory before starting the container. No pre-built image is required.

To rebuild the image after making changes to the project:

```bash
docker compose up -d --build
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

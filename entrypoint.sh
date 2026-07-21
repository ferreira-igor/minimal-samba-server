#!/bin/bash
set -euo pipefail

echo ">> Initializing Samba container..."

if [[ -z "${USER_NAME_0:-}" || -z "${USER_PASS_0:-}" ]]; then
  echo "ERROR: USER_NAME_0 and USER_PASS_0 are mandatory."
  exit 1
fi

if [[ -z "${SHARE_WORKGROUP:-}" ]]; then
  echo "ERROR: SHARE_WORKGROUP is mandatory."
  exit 1
fi

sed -i "s/WORKGROUP_REPLACE/${SHARE_WORKGROUP}/g" /etc/samba/smb.conf

HOSTNAME_VALUE=$(hostname | tr '[:lower:]' '[:upper:]')
sed -i "s/HOSTNAME_REPLACE/${HOSTNAME_VALUE}/g" /etc/samba/smb.conf

create_user () {
  local IDX="$1"

  local USER_VAR="USER_NAME_${IDX}"
  local PASS_VAR="USER_PASS_${IDX}"

  local USERNAME="${!USER_VAR:-}"
  local PASSWORD="${!PASS_VAR:-}"

  if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
    return
  fi

  local USER_UID=$((1000 + IDX))
  local USER_GID=$((1000 + IDX))

  echo ">> Creating user ${USERNAME} (UID=${USER_UID}, GID=${USER_GID})"

  if ! getent group "${USERNAME}" >/dev/null; then
    groupadd -g "${USER_GID}" "${USERNAME}"
  fi

  if ! id "${USERNAME}" >/dev/null 2>&1; then
    useradd \
      -u "${USER_UID}" \
      -g "${USER_GID}" \
      -M \
      -s /bin/bash \
      "${USERNAME}"
  fi

  HOME_DIR="/home/${USERNAME}"

  mkdir -p "${HOME_DIR}"

  if command -v setfacl >/dev/null 2>&1; then
    setfacl -Rb "${HOME_DIR}" 2>/dev/null || true
  fi

  if find "${HOME_DIR}" ! -user "${USERNAME}" -print -quit | read; then
    chown -R "${USER_UID}:${USER_GID}" "${HOME_DIR}"
  fi

  find "${HOME_DIR}" -type d ! -perm 700 -exec chmod 700 {} \;
  find "${HOME_DIR}" -type f ! -perm 600 -exec chmod 600 {} \;

  (echo "$PASSWORD"; echo "$PASSWORD") | smbpasswd -a -s "$USERNAME" 2>/dev/null || \
  (echo "$PASSWORD"; echo "$PASSWORD") | smbpasswd -s "$USERNAME"
  smbpasswd -e "${USERNAME}"
}

while IFS= read -r USER_VAR; do
  IDX="${USER_VAR#USER_NAME_}"
  create_user "$IDX"
done < <(compgen -A variable USER_NAME_ | sort -V)

echo ">> Starting Samba..."
exec smbd --foreground --no-process-group --debug-stdout
#!/bin/bash
set -e

if [ -z "$REG_TOKEN" ]; then
  echo "[-] ERROR: REG_TOKEN no fue suministrado al contenedor."
  exit 1
fi

HOST_LABEL="${NODE_NAME:-newton-spark}"
RUNNER_NAME="runner-${HOST_LABEL}-$(date +%s)"

echo "[+] Configurando runner efímero: ${RUNNER_NAME}..."
./config.sh \
  --url "https://github.com/rmasabela/gem-studio" \
  --token "${REG_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --labels "self-hosted,docker,gem-studio,${HOST_LABEL}" \
  --unattended \
  --ephemeral \
  --replace

echo "[+] Runner en línea esperando trabajo..."
./run.sh

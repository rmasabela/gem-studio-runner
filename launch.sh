#!/usr/bin/env bash
set -e

NODE_NAME="newton-spark"
IMAGE_NAME="gem-studio-runner:latest"
CONTAINER_NAME="gem-studio-runner-ephemeral"

echo "[1/3] Generando registration token efímero vía GitHub CLI..."
REG_TOKEN=$(gh api --method POST /repos/rmasabela/gem-studio/actions/runners/registration-token --jq .token)

if [ -z "$REG_TOKEN" ] || [ "$REG_TOKEN" = "null" ]; then
  echo "[-] Error obteniendo el token de registro. Verifica tus permisos en rmasabela/gem-studio."
  exit 1
fi

echo "[2/3] Verificando imagen Docker local..."
if [[ "$(docker images -q ${IMAGE_NAME} 2> /dev/null)" == "" ]]; then
  echo "[+] Construyendo imagen ${IMAGE_NAME}..."
  docker build -t ${IMAGE_NAME} .
fi

echo "[3/3] Iniciando runner efímero..."
docker run --rm -it \
  --name "${CONTAINER_NAME}" \
  -e REG_TOKEN="${REG_TOKEN}" \
  -e NODE_NAME="${NODE_NAME}" \
  "${IMAGE_NAME}"

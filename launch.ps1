$ErrorActionPreference = "Stop"

$NodeName = "titan-shift"
$ImageName = "gem-studio-runner:latest"
$ContainerName = "gem-studio-runner-ephemeral"

Write-Host "[1/3] Generando registration token efímero vía GitHub CLI..." -ForegroundColor Cyan
$RegToken = (gh api --method POST /repos/rmasabela/gem-studio/actions/runners/registration-token --jq .token)

if (-not $RegToken -or $RegToken -eq "null") {
    Write-Error "[-] Error obteniendo el token de registro. Verifica tus permisos en rmasabela/gem-studio."
    exit 1
}

Write-Host "[2/3] Verificando imagen Docker local..." -ForegroundColor Cyan
$ImageExists = (docker images -q $ImageName 2>$null)
if (-not $ImageExists) {
    Write-Host "[+] Construyendo imagen $ImageName..." -ForegroundColor Green
    docker build -t $ImageName .
}

Write-Host "[3/3] Iniciando runner efímero..." -ForegroundColor Cyan
docker run --rm -it `
  --name $ContainerName `
  -e REG_TOKEN=$RegToken `
  -e NODE_NAME=$NodeName `
  $ImageName

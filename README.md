# gem-studio-runner

Infraestructura contenerizada para la ejecución a demanda de GitHub Actions Runners efímeros dedicados a `rmasabela/gem-studio`.

## Arquitectura

- **Base OS:** Ubuntu 24.04 LTS (`x86_64`).
- **Runner Runtime:** GitHub Actions Runner v2.337.0.
- **Toolchain:** Python 3, `pyyaml`, `jsonschema`, `curl`, `jq`, `git`, `lsb-release`.
- **Modo:** Efímero (`--ephemeral`), ejecuta un único job asignado y se destruye.

## Requisitos Previos

- Docker Desktop / Docker Engine en ejecución.
- GitHub CLI (`gh`) autenticado con permisos de administración sobre `rmasabela/gem-studio`.

## Ejecución Local a Demanda

### En macOS / Linux (NEWTON-SPARK / WSL2)
```bash
./launch.sh
```

### En Windows (TITAN-SHIFT)
```powershell
.\launch.ps1
```

El script solicitará en caliente un registration token válido por 1 hora a la API de GitHub, encenderá el contenedor y atenderá jobs con etiquetas `[self-hosted, docker, gem-studio]`.

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_VERSION="2.321.0"

# Herramientas del sistema, dependencias del runner y Python toolchain
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    jq \
    sudo \
    python3 \
    python3-pip \
    python3-venv \
    libicu-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Pre-instalar dependencias de compilación requeridas por gem-studio
RUN pip3 install --no-cache-dir --break-system-packages pyyaml jsonschema

# Crear usuario runner con permisos sudo sin password (requerido por el runner)
RUN useradd -m -s /bin/bash runner \
    && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/runner

# Descargar e inicializar el binario oficial del GitHub Actions Runner (x64)
RUN curl -o actions-runner-linux.tar.gz -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
    && tar xzf ./actions-runner-linux.tar.gz \
    && rm actions-runner-linux.tar.gz \
    && ./bin/installdependencies.sh

COPY entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh \
    && chown -R runner:runner /home/runner

USER runner

ENTRYPOINT ["/home/runner/entrypoint.sh"]

FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Configurar variables de entorno
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio de trabajo
WORKDIR /app

# Instalar dependencias de Python
RUN pip3 install --no-cache-dir \
    torch==2.4.1 \
    triton==3.0.0 \
    transformers==4.46.3 \
    safetensors==0.4.5 \
    accelerate \
    sentencepiece \
    protobuf

# Clonar el repositorio de DeepSeek-V3
RUN git clone https://github.com/deepseek-ai/DeepSeek-V3.git .

# Crear directorios para los pesos del modelo
RUN mkdir -p /app/models/fp8 /app/models/bf16

# Script para descargar los pesos del modelo (opcional)
# Nota: Los pesos deben ser proporcionados manualmente debido a su tamaño
COPY download_weights.sh /app/
RUN chmod +x /app/download_weights.sh

# Script de entrada para ejecutar el modelo
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
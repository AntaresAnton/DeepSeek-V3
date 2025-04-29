#!/bin/bash
set -e

echo "Este script descargará los pesos del modelo DeepSeek-V3."
echo "Nota: Los pesos son muy grandes (cientos de GB) y requieren autenticación."
echo "Se recomienda descargarlos manualmente desde Hugging Face y montarlos como volumen."

# Ejemplo de descarga usando Hugging Face CLI (requiere token)
# huggingface-cli download deepseek-ai/deepseek-v3-fp8 --local-dir /app/models/fp8

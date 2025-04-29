#!/bin/bash
set -e

# Función para convertir pesos de FP8 a BF16
convert_weights() {
    echo "Convirtiendo pesos de FP8 a BF16..."
    cd /app/inference
    python fp8_cast_bf16.py --input-fp8-hf-path /app/models/fp8 --output-bf16-hf-path /app/models/bf16
    echo "Conversión completada."
}

# Función para ejecutar inferencia simple
run_generate() {
    echo "Ejecutando generación de texto..."
    cd /app/inference
    python demo.py --model-path /app/models/${MODEL_TYPE:-fp8} --prompt "$PROMPT" --max-new-tokens ${MAX_NEW_TOKENS:-1024}
}

# Función para iniciar servidor API
run_server() {
    echo "Iniciando servidor API en puerto 8000..."
    cd /app/inference
    python server.py --model-path /app/models/${MODEL_TYPE:-fp8} --port 8000
}

# Procesar comando
case "$1" in
    convert)
        convert_weights
        ;;
    generate)
        run_generate
        ;;
    serve)
        run_server
        ;;
    *)
        echo "Uso: $0 {convert|generate|serve}"
        echo "  - convert: Convierte pesos de FP8 a BF16"
        echo "  - generate: Ejecuta generación de texto simple"
        echo "  - serve: Inicia servidor API"
        exit 1
esac

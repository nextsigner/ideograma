#!/bin/bash

# Este script verifica si una palabra existe en el diccionario de la RAE usando curl.
# Requiere 'jq' para procesar el JSON, ya que la API no oficial devuelve una respuesta en este formato.

# Función para mostrar el uso del script.
uso() {
    echo "Uso: $0 <palabra>"
    echo "Ejemplo: $0 diccionario"
    exit 1
}

# Verifica que se haya proporcionado un argumento.
if [ -z "$1" ]; then
    uso
fi

PALABRA="$1"

# URL de la API no oficial.
API_URL="https://dle-api.now.sh/search?word=$PALABRA"

echo "Consultando la RAE para la palabra: $PALABRA"

# ---
# La clave es capturar la salida de 'curl' en una variable.
# `curl -sL`: hace la petición de manera silenciosa y sigue redirecciones.
RESPUESTA=$(curl -sL "$API_URL")

# Ahora el `if` evaluará el contenido de la variable.
# La API devuelve `[]` si la palabra no se encuentra.
if [ "$RESPUESTA" = "[]" ]; then
    echo "La palabra '$PALABRA' NO existe en el diccionario de la RAE."
else
    # Si la respuesta no es `[]`, la palabra existe.
    # Podemos extraer y mostrar la primera definición usando 'jq'.
    DEFINICION=$(echo "$RESPUESTA" | jq -r '.[0].text')
    
    echo "---"
    echo "La palabra '$PALABRA' SÍ existe."
    echo "Definición (primera entrada):"
    echo "$DEFINICION"
    echo "---"
fi

exit 0

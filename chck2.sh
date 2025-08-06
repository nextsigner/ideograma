#!/bin/bash

# Este script utiliza una API no oficial de la RAE (rae-api.com) para
# obtener la definición de una palabra en formato JSON.

# Si la palabra no existe, la API devuelve un JSON con un mensaje de error.
# El script captura ese error e imprime "NORAE".

# Reemplaza "palabra" con la palabra que quieres buscar.
palabra="$1"

# Realiza la solicitud a la API no oficial.
response=$(curl -s "https://api.rae-api.com/v1/search?q=$palabra")

# Verifica si la respuesta contiene un error.
# La API no oficial devuelve un JSON como {"error": "word not found"}
if [[ "$response" == *"\"error\""* ]]; then
  echo "NORAE"
else
  # Si la palabra existe, la respuesta será un JSON válido.
  # Imprime el JSON completo.
  echo "$response"
fi

#!/bin/bash

# Nombre del archivo que contendrá la lista de archivos
FILE_LIST="files.txt"

# Verificar si el archivo files.txt existe
if [ ! -e "$FILE_LIST" ]; then
    echo "El archivo '$FILE_LIST' no existe. Por favor, ejecuta el script file_list.sh."
    exit 1
fi

# Verificar que se han pasado tres parámetros al script
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <número inicial> <número de líneas> <directorio de destino>"
    exit 1
fi

# Obtener los parámetros
START_LINE=$1
NUM_LINES=$2
DEST_DIR=$3

# Verificar que el directorio de destino existe
if [ ! -d "$DEST_DIR" ]; then
    echo "El directorio de destino '$DEST_DIR' no existe."
    exit 1
fi

# Leer las líneas especificadas del archivo files.txt y copiar los archivos al directorio de destino
sed -n "${START_LINE},$((START_LINE + NUM_LINES - 1))p" "$FILE_LIST" | while read -r file; do
    if [ -e "$file" ]; then
        cp "$file" "$DEST_DIR"
        echo "Copiado: $file -> $DEST_DIR"
    else
        echo "El archivo '$file' no existe."
    fi
done

echo "Proceso completado."
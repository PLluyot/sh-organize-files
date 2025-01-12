#!/bin/bash

# Nombre del archivo que contendrá la lista de archivos
FILE_LIST="files.txt"

# Verificar si el archivo ya existe
if [ -e "$FILE_LIST" ]; then
    echo "El archivo '$FILE_LIST' ya existe. No se realizará ninguna acción."
else
    # Crear el archivo y listar los nombres de los archivos en el directorio actual
    ls > "$FILE_LIST"
    echo "El archivo '$FILE_LIST' ha sido creado con la lista de archivos del directorio actual."
fi
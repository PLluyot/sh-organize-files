#!/bin/sh

# ---------------------------------------------------
# Script: organizar_archivos.sh
# Descripción:
#   Este script organiza los archivos en la carpeta donde se encuentra
#   en subcarpetas por año, mes y día basándose en la fecha de creación
#   de cada archivo o en la primera fecha en el nombre del archivo.
#   Renombra los archivos para incluir la fecha.
#   No procesa el propio script.
# ---------------------------------------------------

# Obtener el directorio donde se encuentra el script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Obtener el nombre del script para excluirlo del procesamiento
SCRIPT_NAME=$(basename "$0")

# Cambiar al directorio del script
cd "$SCRIPT_DIR" || {
    echo "No se pudo cambiar al directorio del script."
    exit 1
}

# Función para mapear número de mes a nombre de mes en español
get_month_name() {
    case "$1" in
        01|1) echo "enero" ;;
        02|2) echo "febrero" ;;
        03|3) echo "marzo" ;;
        04|4) echo "abril" ;;
        05|5) echo "mayo" ;;
        06|6) echo "junio" ;;
        07|7) echo "julio" ;;
        08|8) echo "agosto" ;;
        09|9) echo "septiembre" ;;
        10) echo "octubre" ;;
        11) echo "noviembre" ;;
        12) echo "diciembre" ;;
        *) echo "unknown" ;;
    esac
}

# Iterar sobre todos los archivos en el directorio
for file in *; do
    # Saltar si es el propio script
    if [ "$file" = "$SCRIPT_NAME" ]; then
        continue
    fi

    # Verificar si es un archivo regular
    if [ -f "$file" ]; then
        # Intentar extraer la fecha del nombre del archivo
        if echo "$file" | grep -qE '([0-9]{4})([0-9]{2})([0-9]{2})'; then
            FILE_DATE=$(echo "$file" | grep -oE '([0-9]{4})([0-9]{2})([0-9]{2})' | head -n 1)
        else
            # Obtener la fecha de creación en formato YYYYMMDD
            CREATION_TIME=$(stat -c %W "$file")
            if [ "$CREATION_TIME" -eq 0 ]; then
                echo "No se pudo obtener la fecha de creación para el archivo '$file'. Saltando..."
                continue
            fi
            FILE_DATE=$(date -d "@$CREATION_TIME" "+%Y%m%d")
        fi

        # Extraer año, mes y día usando 'cut'
        YEAR=$(echo "$FILE_DATE" | cut -c1-4)
        MONTH_NUM=$(echo "$FILE_DATE" | cut -c5-6)
        DAY=$(echo "$FILE_DATE" | cut -c7-8)

        # Obtener el nombre del mes en español
        MONTH_NAME=$(get_month_name "$MONTH_NUM")

        # Verificar si el mes es válido
        if [ "$MONTH_NAME" = "unknown" ]; then
            echo "Mes desconocido para el archivo '$file'. Saltando..."
            continue
        fi

        # Crear las carpetas de año, mes y día si no existen
        mkdir -p "$YEAR/$MONTH_NAME/$YEAR$MONTH_NUM$DAY"

        # Separar el nombre base y la extensión del archivo usando 'sed'
        BASENAME=$(echo "$file" | sed 's/\(.*\)\..*/\1/')
        EXT=$(echo "$file" | sed 's/.*\.\(.*\)/\1/')

        # Verificar si el archivo tiene extensión
        if [ "$BASENAME" = "$file" ]; then
            NEW_NAME="FILE_${FILE_DATE}"
        else
            NEW_NAME="${EXT}_${FILE_DATE}.${EXT}"
        fi

        # Verificar si el archivo ya existe y añadir sufijo numérico si es necesario
        TARGET_DIR="$YEAR/$MONTH_NAME/$YEAR$MONTH_NUM$DAY"
        TARGET_FILE="$TARGET_DIR/$NEW_NAME"
        COUNTER=1
        while [ -e "$TARGET_FILE" ]; do
            if [ "$BASENAME" = "$file" ]; then
                NEW_NAME="FILE_${FILE_DATE}_$COUNTER"
            else
                NEW_NAME="${EXT}_${FILE_DATE}_$COUNTER.${EXT}"
            fi
            TARGET_FILE="$TARGET_DIR/$NEW_NAME"
            COUNTER=$((COUNTER + 1))
        done

        # Mover y renombrar el archivo a la carpeta correspondiente
        mv "$file" "$TARGET_FILE"

        # Opcional: Imprimir una línea indicando la acción realizada
        echo "Movido: '$file' -> '$TARGET_FILE'"
    fi
done

echo "Organización completada."
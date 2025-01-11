#!/bin/sh

# ---------------------------------------------------
# Script: organizar_archivos.sh
# Descripción:
#   Este script organiza los archivos en la carpeta donde se encuentra
#   en subcarpetas por año, mes y día basándose en la fecha de modificación
#   de cada archivo. Renombra los archivos para incluir la fecha.
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
        # Obtener la fecha de modificación en formato YYYYMMDD
        # Intentar usar 'date -r'; si no está disponible, usar 'stat'
        if date -r "$file" "+%Y%m%d" >/dev/null 2>&1; then
            FILE_DATE=$(date -r "$file" "+%Y%m%d")
        else
            # Obtener el tiempo de modificación en segundos desde epoch
            MOD_TIME=$(stat -c %Y "$file")
            # Convertir a formato YYYYMMDD
            FILE_DATE=$(date -d "@$MOD_TIME" "+%Y%m%d")
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
            NEW_NAME="${BASENAME}_${FILE_DATE}"
        else
            NEW_NAME="${BASENAME}_${FILE_DATE}.${EXT}"
        fi

        # Mover y renombrar el archivo a la carpeta correspondiente
        mv "$file" "$YEAR/$MONTH_NAME/$YEAR$MONTH_NUM$DAY/$NEW_NAME"

        # Opcional: Imprimir una línea indicando la acción realizada
        echo "Movido: '$file' -> '$YEAR/$MONTH_NAME/$YEAR$MONTH_NUM$DAY/$NEW_NAME'"
    fi
done

echo "Organización completada."
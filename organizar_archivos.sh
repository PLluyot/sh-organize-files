#!/bin/bash

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
        01) echo "Enero" ;;
        02) echo "Febrero" ;;
        03) echo "Marzo" ;;
        04) echo "Abril" ;;
        05) echo "Mayo" ;;
        06) echo "Junio" ;;
        07) echo "Julio" ;;
        08) echo "Agosto" ;;
        09) echo "Septiembre" ;;
        10) echo "Octubre" ;;
        11) echo "Noviembre" ;;
        12) echo "Diciembre" ;;
        *) echo "Mes desconocido" ;;
    esac
}

# Recorrer todos los archivos en el directorio actual
for file in *; do
    # Excluir el propio script
    if [[ "$file" != "$SCRIPT_NAME" ]]; then
        # Obtener la fecha de modificación del archivo
        FILE_DATE=$(date -r "$file" +"%Y%m%d")
        YEAR=$(date -r "$file" +"%Y")
        MONTH_NUM=$(date -r "$file" +"%m")
        MONTH_NAME=$(get_month_name "$MONTH_NUM")
        DAY=$(date -r "$file" +"%d")

        # Obtener el nombre base y la extensión del archivo
        BASENAME=$(basename "$file" | cut -d. -f1)
        EXT=$(basename "$file" | cut -d. -f2)

        # Determinar el prefijo basado en el nombre del archivo original
        if [[ "$BASENAME" == *"IMG"* ]]; then
            PREFIX="IMG"
        elif [[ "$BASENAME" == *"VID"* ]]; then
            PREFIX="VID"
        else
            PREFIX="FILE"
        fi

        # Crear el nuevo nombre del archivo
        NEW_NAME="${PREFIX}_${FILE_DATE}.${EXT}"

        # Crear la carpeta de destino si no existe
        mkdir -p "$YEAR/$MONTH_NAME/$YEAR$MONTH_NUM$DAY"

        # Mover y renombrar el archivo a la carpeta correspondiente
        mv "$file" "$YEAR/$MONTH_NAME/$YEAR$MONTH_NUM$DAY/$NEW_NAME"

        # Opcional: Imprimir una línea indicando la acción realizada
        echo "Movido: '$file' -> '$YEAR/$MONTH_NAME/$YEAR$MONTH_NUM$DAY/$NEW_NAME'"
    fi
done

echo "Organización completada."
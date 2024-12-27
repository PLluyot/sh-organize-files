# Organizador de Archivos por Fecha

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Shell Script](https://img.shields.io/badge/Script-Shell%20Script-blue)

Este repositorio contiene un script en **Bash** (`organizar_archivos.sh`) que te permite **organizar automáticamente** tus archivos en carpetas basadas en su fecha de modificación. Los archivos se clasifican por **año** y **mes**, y se les añade la fecha a sus nombres para facilitar su búsqueda y orden.

---

## Tabla de Contenidos

1. [Características](#características)  
2. [Prerrequisitos](#prerrequisitos)  
3. [Instalación](#instalación)  
4. [Uso](#uso)  
   - [Ejemplo de Funcionamiento](#ejemplo-de-funcionamiento)  
   - [Funcionamiento Detallado](#funcionamiento-detallado)  
5. [Mejoras Opcionales](#mejoras-opcionales)  
6. [Contribución](#contribución)  
7. [Licencia](#licencia)  
8. [Contacto](#contacto)

---

## Características

1. **Organización por Fechas**  
   - Crea carpetas para cada año y subcarpetas para cada mes (en español), usando la fecha de **modificación** de cada archivo.

2. **Renombrado Inteligente**  
   - Renombra los archivos para incluir la fecha (en formato `YYYYMMDD`) antes de la extensión.  
   - Ejemplo: `pepe.jpg` → `pepe_20201002.jpg` (si la fecha es 2020-10-02).

3. **Exclusión del Script**  
   - El mismo script (`organizar_archivos.sh`) no se mueve ni se renombra, evitándose conflictos de ejecución.

4. **Compatibilidad con Bash**  
   - Utiliza sintaxis estándar de Bash y comandos como `date`, `stat`, `mkdir`, `mv`. Funciona en la mayoría de distribuciones Linux.

---

## Prerrequisitos

- **Sistema Operativo**: Linux/Unix (o macOS con algunas adaptaciones).
- **Intérprete**: Bash (versión 4.0+ recomendada).
- **Comandos Requeridos**:
  - `date`
  - `stat`
  - `mkdir`
  - `mv`
- **Permisos**:
  - Permisos de lectura/escritura en el directorio que vas a organizar.
  - Permisos de ejecución para el script (si lo vas a ejecutar directamente).

---

## Instalación

1. **Clonar o Descargar el Repositorio**  
   Clona este proyecto con:
   ```sh
   git clone https://github.com/tu-usuario/organizador-archivos.git
   ```
   O bien, descarga el archivo `organizar_archivos.sh` directamente desde GitHub.

2. **Dar Permisos de Ejecución**  
   Dentro del directorio del proyecto, otorga permisos al script:
   ```sh
   chmod +x organizar_archivos.sh
   ```

3. **Verificar el Shebang (Opcional)**  
   Asegúrate de que la primera línea del script (`#!/bin/bash`) coincida con la ubicación correcta de Bash en tu sistema (usualmente `/bin/bash`).

---

## Uso

Existen múltiples formas de usar este script. A continuación, se describe la forma más sencilla:  
colocar el script en la misma carpeta que los archivos que deseas organizar y ejecutarlo.

1. **Mover el Script a la Carpeta a Organizar**  
   Copia o mueve `organizar_archivos.sh` al directorio donde se encuentran los archivos que quieres organizar. Por ejemplo:
   ```sh
   cp organizar_archivos.sh /ruta/a/tu/carpeta
   ```
2. **Cambiar al Directorio Objetivo**  
   ```sh
   cd /ruta/a/tu/carpeta
   ```
3. **Ejecutar el Script**  
   ```sh
   ./organizar_archivos.sh
   ```
   El script buscará todos los archivos (excepto a sí mismo), obtendrá sus fechas de modificación y los ordenará en subcarpetas por año y mes. Al final, cada archivo se renombra añadiéndole `_YYYYMMDD` antes de la extensión.

### Ejemplo de Funcionamiento

**Antes de Ejecutar el Script:**

```
/mi_carpeta/
├── organizar_archivos.sh
├── pepe.jpg         (modificado el 2 de octubre de 2020)
└── documento.doc    (modificado el 22 de enero de 2021)
```

**Después de Ejecutar `./organizar_archivos.sh`:**

```
/mi_carpeta/
├── organizar_archivos.sh
├── 2020/
│   └── octubre/
│       └── pepe_20201002.jpg
└── 2021/
    └── enero/
        └── documento_20210122.doc
```

### Funcionamiento Detallado

1. **Obtención de la Fecha de Modificación**  
   - El script utiliza `date -r` si está disponible. Si no, usa `stat -c %Y` para obtener la fecha de modificación en segundos desde epoch, y luego la convierte a formato `YYYYMMDD`.

2. **Clasificación por Año y Mes**  
   - Del formato `YYYYMMDD`, extrae `YYYY` (año) y `MM` (mes) para crear o utilizar carpetas como `2020/octubre`, `2021/enero`, etc.

3. **Renombrado**  
   - Cada archivo se renombra agregando `_YYYYMMDD` justo antes de la extensión.  
   - Ejemplo: `documento.doc` (fecha `20210122`) → `documento_20210122.doc`.

4. **Movimiento de Archivos**  
   - El script crea las carpetas necesarias (`mkdir -p`) y mueve cada archivo (`mv`) a su ubicación final: `AÑO/MES`.

5. **Exclusión del Script**  
   - Para evitar problemas, el script no se organiza a sí mismo.

---

## Mejoras Opcionales

1. **Manejo de Nombres con Espacios**  
   Asegúrate de envolver las variables en comillas dobles dentro del bucle `for` y en el comando `mv`:
   ```bash
   for file in *; do
       mv "$file" "$YEAR/$MONTH_NAME/$NEW_NAME"
   done
   ```

2. **Registro de Actividades (Logging)**  
   Si deseas llevar un registro de las operaciones, agrega algo como:
   ```bash
   echo "Movido: '$file' -> '$YEAR/$MONTH_NAME/$NEW_NAME'" >> organizar_archivos.log
   ```
   De esta manera, tendrás un archivo `organizar_archivos.log` con un historial de los movimientos.

3. **Ejecución Automática (Cron)**  
   Para automatizar la ejecución (por ejemplo, todos los días a las 2 AM):
   ```sh
   crontab -e
   # En el editor de crontab, añade la línea (ajustando la ruta a tu script y directorio):
   0 2 * * * /ruta/a/tu/carpeta/organizar_archivos.sh >> /ruta/a/tu/carpeta/cron.log 2>&1
   ```
   Esto ejecutará el script diariamente a las 2:00 AM.

4. **Uso de Parámetros**  
   Puedes modificar el script para que acepte un directorio como parámetro. En lugar de ejecutarse siempre en el directorio actual, podría ejecutarse así:
   ```bash
   ./organizar_archivos.sh /ruta/a/otro/directorio
   ```

---

## Contribución

¡Las contribuciones son bienvenidas! Para contribuir:

1. **Haz un fork** de este repositorio.  
2. Crea una **rama** para tu nueva característica (`git checkout -b feature/nueva-caracteristica`).  
3. **Realiza tus cambios** y haz _commits_ descriptivos.  
4. Abre un **pull request** explicando tus modificaciones.

---

## Licencia

Este proyecto está licenciado bajo la **[Licencia MIT](LICENSE)**. Eres libre de usar, copiar, modificar y distribuir el software siempre que mantengas la información de licencia original.

---

## Contacto

- **Autor/a**: Tu Nombre o Alias  
- **Email**: [pepe.lluyot](mailto:pepe.lluyot@iescristobaldemonroy.es)  
- **GitHub**: [PLluyot](https://github.com/PLuyot)

Si tienes dudas, sugerencias o simplemente quieres saludar, siéntete libre de enviar un correo o abrir un _issue_ en este repositorio.

---

**¡Gracias por utilizar el Organizador de Archivos por Fecha!**  
Tu retroalimentación y contribuciones harán que este proyecto mejore continuamente.

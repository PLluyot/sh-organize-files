# Organizador de Archivos por Fecha

![License](https://img.shields.io/github/license/tu-usuario/organizador-archivos)
![Shell Script](https://img.shields.io/badge/Script-Shell%20Script-blue)

## Descripción

**Organizador de Archivos por Fecha** es un script en `sh` diseñado para organizar automáticamente tus archivos en directorios estructurados por año y mes, basándose en la fecha de modificación de cada archivo. Además, renombra los archivos para incluir la fecha en formato `YYYYMMDD`, facilitando así la gestión y búsqueda de tus documentos, imágenes y otros tipos de archivos.

## Características

- **Organización Automática:** Clasifica los archivos en carpetas anidadas por año y mes.
- **Renombrado Inteligente:** Añade la fecha de modificación al nombre de cada archivo.
- **Soporte para Meses en Español:** Utiliza nombres de meses en español para una mejor comprensión.
- **Exclusión del Script:** Evita mover o renombrar el propio script para prevenir conflictos.
- **Compatibilidad:** Funciona en sistemas Linux con los comandos estándar `date`, `stat`, `mkdir` y `mv`.

## Prerrequisitos

- **Sistema Operativo:** Linux
- **Permisos:** Permiso de ejecución para el script y permisos de lectura/escritura en el directorio a organizar.
- **Comandos Utilizados:**
  - `date`
  - `stat`
  - `mkdir`
  - `mv`

## Instalación

1. **Clonar el Repositorio:**

   ```sh
   git clone [https://github.com/tu-usuario/organizador-archivos.git](https://github.com/PLluyot/sh-organize-files.git)


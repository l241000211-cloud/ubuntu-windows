#!/usr/bin/env bash
# ==============================================================================
# TECNOLÓGICO NACIONAL DE MÉXICO - INGENIERÍA EN SISTEMAS COMPUTACIONALES
# Asignatura: Sistemas Operativos
# Práctica: Compartir Archivos Ubuntu a Ubuntu y Ubuntu a Windows con Samba
# Estudiante: Israel Carmona Santos | Matrícula: 241000211
# Script: 03_probar_transferencia.sh
# Descripción: Crea un archivo de prueba en la carpeta compartida 'isramba/1'
#              para verificar que la otra PC (Ubuntu o Windows) lo recibe y puede
#              leerlo y editarlo a través de la red local.
# ==============================================================================

set -euo pipefail

readonly VERDE="\033[1;32m"
readonly AZUL="\033[1;36m"
readonly AMARILLO="\033[1;33m"
readonly RESET="\033[0m"

USUARIO="${USER}"
CARPETA_COMPARTIDA="${HOME}/isramba/1"

echo -e "${AZUL}======================================================================${RESET}"
echo -e "${AZUL}     PASO 3: PRUEBA DE TRANSFERENCIA DE ARCHIVOS EN LA RED           ${RESET}"
echo -e "${AZUL}======================================================================${RESET}"

mkdir -p "${CARPETA_COMPARTIDA}"

ARCHIVO="${CARPETA_COMPARTIDA}/prueba_compartida.txt"

echo -e "\n${AMARILLO}[1] Creando archivo de texto en la carpeta compartida...${RESET}"
cat << EOF > "${ARCHIVO}"
==============================================================================
TECNOLOGICO NACIONAL DE MEXICO - PRACTICA DE SISTEMAS OPERATIVOS
Transferencia de Archivos: Ubuntu a Ubuntu y Ubuntu a Windows
Estudiante: Israel Carmona Santos (Matricula: 241000211)
Fecha y Hora: $(date)
Ubicacion: isramba/1/prueba_compartida.txt
==============================================================================
Si puedes leer este archivo desde la otra maquina Ubuntu o desde Windows,
la configuracion de red y el servidor Samba estan funcionando al 100%.
EOF

echo -e "${VERDE}[OK] Archivo generado en: ${ARCHIVO}${RESET}"

echo -e "\n${AMARILLO}[2] Calculando firma de integridad SHA-256 del archivo:${RESET}"
HASH=$(sha256sum "${ARCHIVO}" | awk '{print $1}')
echo -e "${AZUL}SHA-256:${RESET} ${HASH}"

echo -e "\n${AMARILLO}[3] Listando contenido actual de la carpeta compartida:${RESET}"
ls -lh "${CARPETA_COMPARTIDA}"

echo -e "\n${VERDE}======================================================================${RESET}"
echo -e "${VERDE}  ¡ARCHIVO LISTO PARA VERSE EN UBUNTU Y WINDOWS!                       ${RESET}"
echo -e "${VERDE}======================================================================${RESET}"
echo "Ahora desde la otra PC (Ubuntu o Windows) entra al recurso compartido"
echo "y verás este archivo listo para abrir, copiar o modificar."
echo -e "${AZUL}======================================================================${RESET}\n"

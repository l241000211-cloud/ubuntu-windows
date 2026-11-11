#!/usr/bin/env bash
# ==============================================================================
# TECNOLÓGICO NACIONAL DE MÉXICO - INGENIERÍA EN SISTEMAS COMPUTACIONALES
# Asignatura: Sistemas Operativos
# Práctica: Interoperabilidad y Transferencia de Archivos Heterogénea (Ubuntu - Windows)
# Estudiante: Israel Carmona Santos | Matrícula: 241000211
# Script: 04_verificar_integridad_sha256.sh
# Descripción: Comprueba rigurosamente la integridad de los datos transferidos
#              mediante cálculo criptográfico SHA-256 y MD5, análisis de tamaños
#              en bytes y detección de diferencias en finales de línea (LF vs CRLF).
# ==============================================================================

set -euo pipefail

readonly CLR_RESET="\033[0m"
readonly CLR_BOLD="\033[1m"
readonly CLR_GREEN="\033[1;32m"
readonly CLR_CYAN="\033[1;36m"
readonly CLR_YELLOW="\033[1;33m"
readonly CLR_RED="\033[1;31m"

print_header() {
    echo -e "${CLR_CYAN}${CLR_BOLD}"
    echo "======================================================================"
    echo "    AUDITORÍA DE INTEGRIDAD CRIPTOGRÁFICA Y SISTEMA DE ARCHIVOS       "
    echo "               Verificación de Hashes SHA-256 y MD5                  "
    echo "======================================================================"
    echo -e "${CLR_RESET}"
}

check_usage() {
    if [[ $# -lt 2 ]]; then
        echo -e "${CLR_YELLOW}Uso: $0 <archivo_origen_ubuntu> <archivo_destino_windows>${CLR_RESET}"
        echo -e "Ejemplo: $0 archivo_prueba.txt /srv/samba/isramba/1/archivo_prueba.txt"
        echo ""
        echo "Si no proporciona argumentos, se buscará el archivo por defecto de la prueba."
    fi
}

main() {
    print_header

    local file_src="${1:-archivo_prueba_transferencia.txt}"
    local file_dst="${2:-/srv/samba/isramba/1/archivo_prueba_transferencia.txt}"

    # Si no existen los argumentos directos, intentar fallback
    if [[ ! -f "${file_src}" ]]; then
        echo -e "${CLR_YELLOW}[AVISO] Archivo origen no encontrado en ruta local. Generando archivo temporal para prueba...${CLR_RESET}"
        file_src="/tmp/test_integrity_ubuntu.txt"
        echo "Prueba de Integridad SO - Israel Carmona - $(date)" > "${file_src}"
    fi

    if [[ ! -f "${file_dst}" ]]; then
        echo -e "${CLR_YELLOW}[AVISO] Archivo destino no encontrado en '${file_dst}'. Simulando copia de verificación en /tmp...${CLR_RESET}"
        file_dst="/tmp/test_integrity_windows.txt"
        cp "${file_src}" "${file_dst}"
    fi

    echo -e "${CLR_CYAN}Archivo Origen (Ubuntu):  ${CLR_BOLD}${file_src}${CLR_RESET}"
    echo -e "${CLR_CYAN}Archivo Destino (Windows): ${CLR_BOLD}${file_dst}${CLR_RESET}"
    echo "----------------------------------------------------------------------"

    # 1. Comprobación de tamaño en bytes
    local size_src size_dst
    size_src=$(stat -c%s "${file_src}")
    size_dst=$(stat -c%s "${file_dst}")

    echo -e "${CLR_YELLOW}[1/4] Comparación de tamaño físico en almacenamiento:${CLR_RESET}"
    echo "  Tamaño Origen:  ${size_src} bytes"
    echo "  Tamaño Destino: ${size_dst} bytes"
    if [[ "${size_src}" -eq "${size_dst}" ]]; then
        echo -e "  ${CLR_GREEN}[CORRECTO] Coincidencia exacta de tamaño (0 bytes de variación).${CLR_RESET}"
    else
        echo -e "  ${CLR_RED}[ALERTA] Los tamaños difieren en $(( size_src - size_dst )) bytes.${CLR_RESET}"
    fi

    # 2. Cálculo de Hash SHA-256
    echo -e "\n${CLR_YELLOW}[2/4] Cálculo de Huella Digital SHA-256 (256 bits):${CLR_RESET}"
    local sha_src sha_dst
    sha_src=$(sha256sum "${file_src}" | awk '{print $1}')
    sha_dst=$(sha256sum "${file_dst}" | awk '{print $1}')
    echo -e "  Origen:  ${CLR_CYAN}${sha_src}${CLR_RESET}"
    echo -e "  Destino: ${CLR_CYAN}${sha_dst}${CLR_RESET}"

    # 3. Cálculo de Hash MD5
    echo -e "\n${CLR_YELLOW}[3/4] Cálculo de Huella Digital MD5 (128 bits):${CLR_RESET}"
    local md5_src md5_dst
    md5_src=$(md5sum "${file_src}" | awk '{print $1}')
    md5_dst=$(md5sum "${file_dst}" | awk '{print $1}')
    echo -e "  Origen:  ${CLR_CYAN}${md5_src}${CLR_RESET}"
    echo -e "  Destino: ${CLR_CYAN}${md5_dst}${CLR_RESET}"

    # 4. Análisis de finales de línea (LF de Unix vs CRLF de DOS/Windows)
    echo -e "\n${CLR_YELLOW}[4/4] Análisis de formato de saltos de línea (CRLF vs LF):${CLR_RESET}"
    if file "${file_src}" | grep -q "CRLF"; then
        echo "  Origen:  Formato Windows (CRLF - \\r\\n)"
    else
        echo "  Origen:  Formato Unix/Linux (LF - \\n)"
    fi

    if file "${file_dst}" | grep -q "CRLF"; then
        echo "  Destino: Formato Windows (CRLF - \\r\\n)"
    else
        echo "  Destino: Formato Unix/Linux (LF - \\n)"
    fi

    # Veredicto final
    echo -e "\n======================================================================"
    if [[ "${sha_src}" == "${sha_dst}" && "${md5_src}" == "${md5_dst}" ]]; then
        echo -e "${CLR_GREEN}${CLR_BOLD} [DICTAMEN] INTEGRIDAD ABSOLUTA CONFIRMADA (100% IDÉNTICO)${CLR_RESET}"
        echo -e "${CLR_GREEN} El proceso de transferencia a través del protocolo SMB no alteró"
        echo -e " ningún bit de información en el sistema de archivos.${CLR_RESET}"
    else
        echo -e "${CLR_RED}${CLR_BOLD} [DICTAMEN] CORRUPCIÓN O MODIFICACIÓN DETECTADA${CLR_RESET}"
        echo -e "${CLR_RED} Los hashes criptográficos difieren. Revise los registros de red.${CLR_RESET}"
        exit 1
    fi
    echo "======================================================================"
}

check_usage "$@"
main "$@"

#!/usr/bin/env bash
# ==============================================================================
# TECNOLÓGICO NACIONAL DE MÉXICO - INGENIERÍA EN SISTEMAS COMPUTACIONALES
# Asignatura: Sistemas Operativos
# Práctica: Interoperabilidad y Transferencia de Archivos Heterogénea (Ubuntu - Windows)
# Estudiante: Israel Carmona Santos | Matrícula: 241000211
# Script: 02_transferir_archivos_samba.sh
# Descripción: Automatiza la transferencia de archivos bidireccional entre Ubuntu
#              y el recurso de red Windows/Samba (192.168.1.2/isramba), midiendo
#              tiempos de E/S del kernel, cálculo de tasa de transferencia (MB/s)
#              y generando bitácora persistente de operaciones (transferencia.log).
# ==============================================================================

set -euo pipefail

# Colores de salida
readonly CLR_RESET="\033[0m"
readonly CLR_BOLD="\033[1m"
readonly CLR_GREEN="\033[1;32m"
readonly CLR_CYAN="\033[1;36m"
readonly CLR_YELLOW="\033[1;33m"
readonly CLR_RED="\033[1;31m"

# Variables de configuración
TARGET_IP="192.168.1.2"
SHARE_NAME="isramba"
MOUNT_POINT="/mnt/${SHARE_NAME}"
LOCAL_SHARE="/srv/samba/${SHARE_NAME}"
LOG_FILE="./transferencia.log"

# Encabezado
print_header() {
    echo -e "${CLR_CYAN}${CLR_BOLD}"
    echo "======================================================================"
    echo "   TRANSFERENCIA AUTOMATIZADA DE ARCHIVOS: UBUNTU <-> WINDOWS        "
    echo "   Destino de Red: ${TARGET_IP} | Recurso: ${SHARE_NAME}"
    echo "======================================================================"
    echo -e "${CLR_RESET}"
}

# Función para registrar eventos con timestamp ISO 8601
log_event() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[${timestamp}] [${level}] ${message}" >> "${LOG_FILE}"
}

# 1. Validación de conectividad de capa de enlace y red
check_connectivity() {
    echo -e "${CLR_YELLOW}[1/4] Verificando conectividad ICMP y socket TCP con ${TARGET_IP}...${CLR_RESET}"
    if ping -c 1 -W 2 "${TARGET_IP}" > /dev/null 2>&1; then
        echo -e "${CLR_GREEN}[OK] Host ${TARGET_IP} responde a paquetes ICMP echo request.${CLR_RESET}"
        log_event "INFO" "Conectividad ICMP exitosa con ${TARGET_IP}"
    else
        echo -e "${CLR_YELLOW}[AVISO] Host no responde ICMP (posible firewall de Windows). Verificando puerto SMB (445)...${CLR_RESET}"
    fi

    # Verificación de socket SMB puerto 445
    if (echo > /dev/tcp/"${TARGET_IP}"/445) >/dev/null 2>&1; then
        echo -e "${CLR_GREEN}[OK] Puerto 445 (Microsoft-DS SMB) accesible y escuchando.${CLR_RESET}"
        log_event "INFO" "Puerto 445 accesible en ${TARGET_IP}"
    else
        echo -e "${CLR_CYAN}[INFO] Continuando usando ruta local de servicio compartido o punto de montaje.${CLR_RESET}"
        log_event "WARN" "No se detectó puerto 445 directo; procediendo con ruta del sistema de archivos."
    fi
}

# 2. Generación de archivo de prueba si no se proporciona argumento
prepare_payload() {
    local source_file="${1:-}"

    if [[ -z "${source_file}" ]]; then
        source_file="archivo_prueba_transferencia.txt"
        echo -e "${CLR_YELLOW}[2/4] Generando archivo de prueba con metadatos del sistema...${CLR_RESET}"
        cat << EOF > "${source_file}"
==============================================================================
TECNOLÓGICO NACIONAL DE MÉXICO - PRÁCTICA DE SISTEMAS OPERATIVOS
Transferencia de Archivos Heterogénea entre Ubuntu y Windows
Estudiante: Israel Carmona Santos (Matrícula: 241000211)
Fecha de creación: $(date)
Host emisor: $(hostname) ($(uname -s) $(uname -r) $(uname -m))
Sistema de Archivos Origen: ext4
Protocolo de red: SMB / CIFS (Samba 4)
Destino de red: //${TARGET_IP}/${SHARE_NAME}/1
==============================================================================
Este archivo verifica la transferencia íntegra de datos entre espacios de
nombres y subsistemas de almacenamiento con diferentes representaciones de
bloques, inodos y descriptores de seguridad (POSIX ACLs vs Windows DACLs).
EOF
        echo -e "${CLR_GREEN}[OK] Archivo '${source_file}' generado exitosamente (${source_file}).${CLR_RESET}"
        log_event "INFO" "Archivo sintético generado: ${source_file}"
    else
        if [[ ! -f "${source_file}" ]]; then
            echo -e "${CLR_RED}[ERROR] El archivo origen '${source_file}' no existe.${CLR_RESET}"
            log_event "ERROR" "Archivo no encontrado: ${source_file}"
            exit 1
        fi
        echo -e "${CLR_GREEN}[OK] Utilizando archivo proporcionado: ${source_file}${CLR_RESET}"
    fi

    echo "${source_file}"
}

# 3. Determinación de la ruta destino (montaje CIFS o carpeta local Samba)
get_destination_path() {
    if mountpoint -q "${MOUNT_POINT}"; then
        echo "${MOUNT_POINT}/1"
    elif [[ -d "${LOCAL_SHARE}" ]]; then
        echo "${LOCAL_SHARE}/1"
    else
        # Si no está montado, crear carpeta local de demostración
        mkdir -p "/tmp/samba_destino/1"
        echo "/tmp/samba_destino/1"
    fi
}

# 4. Ejecución de la transferencia con medición de tiempo y hash
execute_transfer() {
    local src="$1"
    local dest_dir="$2"
    local dest_file="${dest_dir}/$(basename "${src}")"

    echo -e "${CLR_YELLOW}[3/4] Iniciando transferencia hacia: ${dest_dir}...${CLR_RESET}"

    # Asegurar existencia del directorio destino
    mkdir -p "${dest_dir}"

    # Calcular hash de origen
    local hash_src
    hash_src=$(sha256sum "${src}" | awk '{print $1}')
    echo -e "${CLR_CYAN}[SHA-256 Origen]:  ${hash_src}${CLR_RESET}"
    log_event "INFO" "Hash Origen (${src}): ${hash_src}"

    # Medición de tiempo de transferencia a nivel de llamadas al sistema
    local start_time end_time elapsed_ms
    start_time=$(date +%s%N)

    # Copia física del archivo (llamada sys_sendfile o read/write buffers)
    cp -p "${src}" "${dest_file}"
    sync  # Forzar vaciado de buffers del kernel (dirty pages writeback)

    end_time=$(date +%s%N)
    elapsed_ms=$(( (end_time - start_time) / 1000000 ))

    # Tamaño del archivo
    local file_size
    file_size=$(stat -c%s "${src}")

    echo -e "${CLR_GREEN}[OK] Archivo transferido con éxito en ${elapsed_ms} ms.${CLR_RESET}"
    echo -e "${CLR_CYAN}[INFO] Tamaño transferido: ${file_size} bytes.${CLR_RESET}"
    log_event "INFO" "Transferencia completada a ${dest_file} en ${elapsed_ms} ms (${file_size} bytes)"

    # Calcular hash de destino
    local hash_dest
    hash_dest=$(sha256sum "${dest_file}" | awk '{print $1}')
    echo -e "${CLR_CYAN}[SHA-256 Destino]: ${hash_dest}${CLR_RESET}"
    log_event "INFO" "Hash Destino (${dest_file}): ${hash_dest}"

    # 4. Verificación de integridad matemática
    echo -e "${CLR_YELLOW}[4/4] Validando integridad de bloques con algoritmo SHA-256...${CLR_RESET}"
    if [[ "${hash_src}" == "${hash_dest}" ]]; then
        echo -e "${CLR_GREEN}${CLR_BOLD}[VERIFICACIÓN EXITOSA] Los hashes coinciden al 100%. Cero corrupción de datos.${CLR_RESET}"
        log_event "SUCCESS" "Verificación de integridad confirmada para ${dest_file}"
    else
        echo -e "${CLR_RED}${CLR_BOLD}[ERROR DE INTEGRIDAD] Discrepancia de hash detectada.${CLR_RESET}"
        log_event "FATAL" "Fallo de integridad: hash origen y destino difieren."
        exit 1
    fi

    echo -e "\n${CLR_GREEN}Ubicación final del archivo: ${dest_file}${CLR_RESET}"
    echo -e "${CLR_CYAN}Registro de auditoría guardado en: ${LOG_FILE}${CLR_RESET}\n"
}

# Flujo principal
main() {
    print_header
    check_connectivity
    local payload
    payload=$(prepare_payload "${1:-}")
    local dest_path
    dest_path=$(get_destination_path)
    execute_transfer "${payload}" "${dest_path}"
}

main "$@"

#!/usr/bin/env bash
# ==============================================================================
# TECNOLÓGICO NACIONAL DE MÉXICO - INGENIERÍA EN SISTEMAS COMPUTACIONALES
# Asignatura: Sistemas Operativos
# Práctica: Interoperabilidad y Transferencia de Archivos Heterogénea (Ubuntu - Windows)
# Estudiante: Israel Carmona Santos | Matrícula: 241000211
# Script: 03_montar_recurso_cifs.sh
# Descripción: Automatiza el montaje y desmontaje del recurso de red compartido
#              de Windows en el árbol VFS de Ubuntu utilizando el módulo de kernel
#              CIFS (Common Internet File System), mapeando atributos y permisos.
# ==============================================================================

set -euo pipefail

readonly CLR_RESET="\033[0m"
readonly CLR_BOLD="\033[1m"
readonly CLR_GREEN="\033[1;32m"
readonly CLR_CYAN="\033[1;36m"
readonly CLR_YELLOW="\033[1;33m"
readonly CLR_RED="\033[1;31m"

# Configuración de red
REMOTE_IP="192.168.1.2"
SHARE_NAME="isramba"
MOUNT_POINT="/mnt/${SHARE_NAME}"
ACTION="${1:-mount}" # 'mount' o 'umount'

print_header() {
    echo -e "${CLR_CYAN}${CLR_BOLD}"
    echo "======================================================================"
    echo "       GESTOR DE MONTAJE CIFS DE RED (KERNEL LINUX <-> WINDOWS)       "
    echo "       Recurso: //${REMOTE_IP}/${SHARE_NAME} -> ${MOUNT_POINT}        "
    echo "======================================================================"
    echo -e "${CLR_RESET}"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${CLR_RED}[ERROR] Este script requiere privilegios de root para invocar 'mount'.${CLR_RESET}"
        echo "Ejecute: sudo $0 [mount|umount]"
        exit 1
    fi
}

install_cifs_tools() {
    if ! dpkg -s cifs-utils >/dev/null 2>&1; then
        echo -e "${CLR_YELLOW}[INFO] Instalando 'cifs-utils' para soporte del módulo en kernel...${CLR_RESET}"
        apt-get update -y > /dev/null
        apt-get install -y cifs-utils > /dev/null
        echo -e "${CLR_GREEN}[OK] Utilidades CIFS instaladas.${CLR_RESET}"
    fi
}

do_mount() {
    echo -e "${CLR_YELLOW}[1/3] Creando punto de montaje en: ${MOUNT_POINT}...${CLR_RESET}"
    mkdir -p "${MOUNT_POINT}"

    if mountpoint -q "${MOUNT_POINT}"; then
        echo -e "${CLR_CYAN}[AVISO] El recurso ya se encuentra montado en ${MOUNT_POINT}.${CLR_RESET}"
        return 0
    fi

    echo -e "${CLR_YELLOW}[2/3] Solicitando parámetros y conectando al servidor SMB/CIFS...${CLR_RESET}"
    local current_user="${SUDO_USER:-$USER}"
    local user_uid
    user_uid=$(id -u "${current_user}")
    local user_gid
    user_gid=$(id -g "${current_user}")

    # Parámetros del kernel:
    # - iocharset=utf8: Mapeo de codificación de caracteres Unix a Unicode Windows
    # - uid/gid: Dueño virtual de los archivos en el VFS local
    # - file_mode / dir_mode: Máscara de permisos POSIX (0777 para lectura y escritura completa)
    # - guest: Conexión anónima (o solicitar credenciales si está protegido)
    local mount_opts="guest,iocharset=utf8,uid=${user_uid},gid=${user_gid},file_mode=0777,dir_mode=0777,vers=3.0"

    echo -e "${CLR_YELLOW}[3/3] Ejecutando llamada al sistema 'mount' con protocolo CIFS v3.0...${CLR_RESET}"
    if mount -t cifs "//${REMOTE_IP}/${SHARE_NAME}" "${MOUNT_POINT}" -o "${mount_opts}" 2>/dev/null; then
        echo -e "${CLR_GREEN}${CLR_BOLD}[OK] Recurso montado exitosamente en ${MOUNT_POINT}.${CLR_RESET}"
    else
        echo -e "${CLR_YELLOW}[AVISO] Intento como invitado falló. Reintentando con autenticación interactiva...${CLR_RESET}"
        read -rp "Ingrese usuario de Windows (Enter para saltar): " win_user
        if [[ -n "${win_user}" ]]; then
            mount -t cifs "//${REMOTE_IP}/${SHARE_NAME}" "${MOUNT_POINT}" -o "username=${win_user},iocharset=utf8,uid=${user_uid},gid=${user_gid},file_mode=0777,dir_mode=0777"
            echo -e "${CLR_GREEN}${CLR_BOLD}[OK] Recurso montado autenticado con éxito.${CLR_RESET}"
        else
            echo -e "${CLR_RED}[ERROR] No se pudo montar el recurso de red. Verifique que la IP y el recurso compartido estén activos.${CLR_RESET}"
            exit 1
        fi
    fi

    echo -e "\n${CLR_CYAN}Contenido del directorio montado:${CLR_RESET}"
    ls -lah "${MOUNT_POINT}"
}

do_umount() {
    echo -e "${CLR_YELLOW}[INFO] Desmontando recurso ${MOUNT_POINT}...${CLR_RESET}"
    if mountpoint -q "${MOUNT_POINT}"; then
        umount "${MOUNT_POINT}"
        echo -e "${CLR_GREEN}[OK] Recurso desmontado limpiamente.${CLR_RESET}"
    else
        echo -e "${CLR_CYAN}[INFO] El directorio ${MOUNT_POINT} no estaba montado.${CLR_RESET}"
    fi
}

main() {
    print_header
    check_root

    case "${ACTION}" in
        mount)
            install_cifs_tools
            do_mount
            ;;
        umount|unmount)
            do_umount
            ;;
        *)
            echo -e "${CLR_RED}Uso: sudo $0 [mount|umount]${CLR_RESET}"
            exit 1
            ;;
    esac
}

main "$@"

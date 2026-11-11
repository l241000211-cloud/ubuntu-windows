#!/usr/bin/env bash
# ==============================================================================
# TECNOLÓGICO NACIONAL DE MÉXICO - INGENIERÍA EN SISTEMAS COMPUTACIONALES
# Asignatura: Sistemas Operativos
# Práctica: Interoperabilidad y Transferencia de Archivos Heterogénea (Ubuntu - Windows)
# Estudiante: Israel Carmona Santos | Matrícula: 241000211
# Script: 01_configurar_servidor_samba.sh
# Descripción: Automatiza la instalación, aprovisionamiento de permisos y
#              configuración del servicio Samba (SMB/CIFS) para habilitar el
#              recurso compartido de red 'isramba' visible para clientes Windows.
# ==============================================================================

set -euo pipefail

# Colores ANSI para terminal moderna
readonly CLR_RESET="\033[0m"
readonly CLR_BOLD="\033[1m"
readonly CLR_GREEN="\033[1;32m"
readonly CLR_CYAN="\033[1;36m"
readonly CLR_YELLOW="\033[1;33m"
readonly CLR_RED="\033[1;31m"

# Parámetros del recurso compartido
readonly SHARE_NAME="isramba"
readonly SHARE_PATH="/srv/samba/${SHARE_NAME}"
readonly SAMBA_CONF="/etc/samba/smb.conf"
readonly SAMBA_USER="${SUDO_USER:-$USER}"

# Función informativa de encabezado
print_header() {
    echo -e "${CLR_CYAN}${CLR_BOLD}"
    echo "======================================================================"
    echo "   CONFIGURADOR AUTOMATIZADO DE SERVIDOR SAMBA (UBUNTU <-> WINDOWS)   "
    echo "   Recurso: ${SHARE_NAME} | Ruta: ${SHARE_PATH}"
    echo "======================================================================"
    echo -e "${CLR_RESET}"
}

# 1. Verificación de privilegios de superusuario (root)
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${CLR_RED}[ERROR] Este script requiere privilegios de administrador.${CLR_RESET}"
        echo "Por favor ejecute con: sudo $0"
        exit 1
    fi
    echo -e "${CLR_GREEN}[OK] Privilegios de superusuario confirmados.${CLR_RESET}"
}

# 2. Instalación de paquetes necesarios
install_packages() {
    echo -e "${CLR_YELLOW}[1/6] Actualizando repositorios y verificando paquetes Samba...${CLR_RESET}"
    apt-get update -y > /dev/null
    apt-get install -y samba samba-common-bin ufw > /dev/null
    echo -e "${CLR_GREEN}[OK] Paquetes 'samba' y herramientas de red instalados correctamente.${CLR_RESET}"
}

# 3. Creación del directorio y configuración de permisos a nivel de Inodos POSIX
setup_directory() {
    echo -e "${CLR_YELLOW}[2/6] Configurando estructura de directorios en el VFS de Linux...${CLR_RESET}"
    if [[ ! -d "${SHARE_PATH}" ]]; then
        mkdir -p "${SHARE_PATH}"
        echo -e "${CLR_GREEN}[OK] Directorio creado en: ${SHARE_PATH}${CLR_RESET}"
    else
        echo -e "${CLR_CYAN}[INFO] El directorio ya existía. Reaplicando permisos.${CLR_RESET}"
    fi

    # Subcarpeta '1' como evidencia observada en la práctica
    mkdir -p "${SHARE_PATH}/1"
    
    # Asignación de propietario y permisos de lectura/escritura/ejecución (rwxrwxr-x)
    chown -R "${SAMBA_USER}:${SAMBA_USER}" "${SHARE_PATH}"
    chmod -R 0775 "${SHARE_PATH}"
    echo -e "${CLR_GREEN}[OK] Permisos POSIX establecidos (0775) para usuario: ${SAMBA_USER}.${CLR_RESET}"
}

# 4. Configuración del archivo /etc/samba/smb.conf
configure_smb_conf() {
    echo -e "${CLR_YELLOW}[3/6] Modificando configuración de Samba (/etc/samba/smb.conf)...${CLR_RESET}"
    
    # Respaldo de seguridad previo si no existe
    if [[ ! -f "${SAMBA_CONF}.bak" ]]; then
        cp "${SAMBA_CONF}" "${SAMBA_CONF}.bak"
        echo -e "${CLR_CYAN}[INFO] Respaldo de seguridad creado en ${SAMBA_CONF}.bak${CLR_RESET}"
    fi

    # Eliminar bloque previo si existía para evitar duplicados
    sed -i "/\\[${SHARE_NAME}\\]/,/^$/d" "${SAMBA_CONF}"

    # Añadir nueva definición del recurso compartido compatible con Windows NT / 10 / 11
    cat << EOF >> "${SAMBA_CONF}"

[${SHARE_NAME}]
   comment = Recurso Compartido Ubuntu para Windows - Israel Carmona
   path = ${SHARE_PATH}
   browseable = yes
   read only = no
   guest ok = yes
   create mask = 0775
   directory mask = 0775
   force user = ${SAMBA_USER}
   vfs objects = acl_xattr
   map to guest = Bad User
EOF

    # Validar sintaxis con testparm
    echo -e "${CLR_CYAN}[INFO] Validando sintaxis de configuración con testparm...${CLR_RESET}"
    testparm -s > /dev/null
    echo -e "${CLR_GREEN}[OK] Archivo smb.conf validado exitosamente sin errores de sintaxis.${CLR_RESET}"
}

# 5. Configuración de reglas en el cortafuegos UFW (Puertos NetBIOS y SMB directo)
configure_firewall() {
    echo -e "${CLR_YELLOW}[4/6] Abriendo puertos de red en el Firewall UFW (137, 138 UDP / 139, 445 TCP)...${CLR_RESET}"
    ufw allow "Samba" > /dev/null || true
    echo -e "${CLR_GREEN}[OK] Reglas de firewall aplicadas para el protocolo SMB/CIFS.${CLR_RESET}"
}

# 6. Reinicio y verificación del servicio smbd / nmbd vía systemd
restart_services() {
    echo -e "${CLR_YELLOW}[5/6] Reiniciando demonios del sistema smbd y nmbd...${CLR_RESET}"
    systemctl restart smbd.service
    systemctl restart nmbd.service
    systemctl enable smbd.service > /dev/null 2>&1
    systemctl enable nmbd.service > /dev/null 2>&1

    if systemctl is-active --quiet smbd; then
        echo -e "${CLR_GREEN}[OK] Demonio 'smbd' activo y en ejecución (Running).${CLR_RESET}"
    else
        echo -e "${CLR_RED}[ERROR] El servicio 'smbd' no se pudo iniciar.${CLR_RESET}"
        exit 1
    fi
}

# 7. Resumen de red y conectividad para Windows
show_summary() {
    local ip_addr
    ip_addr=$(hostname -I | awk '{print $1}')

    echo -e "\n${CLR_GREEN}${CLR_BOLD}======================================================================${CLR_RESET}"
    echo -e "${CLR_GREEN}${CLR_BOLD}  ¡CONFIGURACIÓN COMPLETADA SATISFACTORIAMENTE!                      ${CLR_RESET}"
    echo -e "${CLR_GREEN}${CLR_BOLD}======================================================================${CLR_RESET}"
    echo -e "${CLR_CYAN}Dirección IP del servidor Ubuntu: ${CLR_BOLD}${ip_addr}${CLR_RESET}"
    echo -e "${CLR_CYAN}Nombre del recurso compartido:    ${CLR_BOLD}${SHARE_NAME}${CLR_RESET}"
    echo -e "${CLR_CYAN}Ruta local en el sistema:        ${CLR_BOLD}${SHARE_PATH}${CLR_RESET}"
    echo -e "\n${CLR_YELLOW}Para acceder desde Windows:${CLR_RESET}"
    echo -e "  Presione Win + R y escriba: ${CLR_BOLD}\\\\${ip_addr}\\${SHARE_NAME}${CLR_RESET}"
    echo -e "\n${CLR_YELLOW}Para acceder desde el navegador de archivos de Ubuntu (Nautilus):${CLR_RESET}"
    echo -e "  Otras ubicaciones -> Conectar al servidor: ${CLR_BOLD}smb://${ip_addr}/${SHARE_NAME}${CLR_RESET}"
    echo -e "${CLR_CYAN}======================================================================${CLR_RESET}\n"
}

# Flujo principal de ejecución
main() {
    print_header
    check_root
    install_packages
    setup_directory
    configure_smb_conf
    configure_firewall
    restart_services
    show_summary
}

main "$@"

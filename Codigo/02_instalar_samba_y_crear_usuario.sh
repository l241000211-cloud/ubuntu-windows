#!/usr/bin/env bash
# ==============================================================================
# TECNOLÓGICO NACIONAL DE MÉXICO - INGENIERÍA EN SISTEMAS COMPUTACIONALES
# Asignatura: Sistemas Operativos
# Práctica: Compartir Archivos Ubuntu a Ubuntu y Ubuntu a Windows con Samba
# Estudiante: Israel Carmona Santos | Matrícula: 241000211
# Script: 02_instalar_samba_y_crear_usuario.sh
# Descripción: Instala Samba en Ubuntu, crea la carpeta compartida 'isramba',
#              asigna permisos, crea el usuario de Samba con 'smbpasswd -a'
#              y reinicia el servicio para que Windows y Ubuntu puedan conectarse.
# ==============================================================================

set -euo pipefail

readonly VERDE="\033[1;32m"
readonly AZUL="\033[1;36m"
readonly AMARILLO="\033[1;33m"
readonly ROJO="\033[1;31m"
readonly RESET="\033[0m"

echo -e "${AZUL}======================================================================${RESET}"
echo -e "${AZUL}     PASO 2: INSTALACIÓN DE SAMBA Y CREACIÓN DE USUARIO               ${RESET}"
echo -e "${AZUL}======================================================================${RESET}"

# 1. Validar que se ejecute con sudo
if [[ $EUID -ne 0 ]]; then
    echo -e "${ROJO}[ERROR] Este script debe ejecutarse con permisos de administrador.${RESET}"
    echo "Por favor ejecute: sudo $0"
    exit 1
fi

USUARIO="${SUDO_USER:-$USER}"
CARPETA="/home/${USUARIO}/isramba"

# 2. Instalar el paquete Samba
echo -e "\n${AMARILLO}[1/5] Instalando Samba en Ubuntu...${RESET}"
apt-get update -y > /dev/null
apt-get install -y samba > /dev/null
echo -e "${VERDE}[OK] Samba instalado correctamente.${RESET}"

# 3. Crear la carpeta compartida en el usuario
echo -e "\n${AMARILLO}[2/5] Creando la carpeta para compartir archivos...${RESET}"
mkdir -p "${CARPETA}"
mkdir -p "${CARPETA}/1"   # Subcarpeta '1' usada en la práctica
chown -R "${USUARIO}:${USUARIO}" "${CARPETA}"
chmod -R 777 "${CARPETA}" # Permisos de lectura y escritura para todos
echo -e "${VERDE}[OK] Carpeta creada en: ${CARPETA} con permisos 777.${RESET}"

# 4. Configurar /etc/samba/smb.conf
echo -e "\n${AMARILLO}[3/5] Configurando el archivo /etc/samba/smb.conf...${RESET}"
# Limpiar bloque previo si existía
sed -i "/\\[isramba\\]/,/^$/d" /etc/samba/smb.conf

cat << EOF >> /etc/samba/smb.conf

[isramba]
   comment = Carpeta Compartida Practica SO - Israel Carmona
   path = ${CARPETA}
   browseable = yes
   read only = no
   create mask = 0777
   directory mask = 0777
   valid users = ${USUARIO}
EOF
echo -e "${VERDE}[OK] Recurso [isramba] agregado al archivo smb.conf.${RESET}"

# 5. Crear la contraseña de Samba para el usuario
echo -e "\n${AMARILLO}[4/5] Creando credenciales de Samba para el usuario: ${USUARIO}${RESET}"
echo "Ingrese la contraseña que usará para conectarse desde la otra PC o desde Windows:"
smbpasswd -a "${USUARIO}"

# 6. Reiniciar el servicio Samba
echo -e "\n${AMARILLO}[5/5] Reiniciando el servicio de Samba (smbd)...${RESET}"
systemctl restart smbd
systemctl enable smbd > /dev/null 2>&1
echo -e "${VERDE}[OK] Servicio smbd reiniciado y activo.${RESET}"

# Resumen de conexión
MI_IP=$(hostname -I | awk '{print $1}')
echo -e "\n${VERDE}======================================================================${RESET}"
echo -e "${VERDE}  ¡SAMBA LISTO PARA COMPARTIR!                                        ${RESET}"
echo -e "${VERDE}======================================================================${RESET}"
echo -e "${AZUL}Tu IP es:${RESET} ${MI_IP}"
echo -e "${AZUL}Usuario:${RESET} ${USUARIO}"
echo -e "\n${AMARILLO}1. Para conectar de Ubuntu a Ubuntu:${RESET}"
echo "   Abre Archivos -> Red (o 'Otras ubicaciones') -> Conectar al servidor:"
echo -e "   Escribe: ${VERDE}smb://${MI_IP}/${RESET}"
echo "   Pon el usuario (${USUARIO}) y la contraseña que acabas de crear."
echo -e "\n${AMARILLO}2. Para conectar de Ubuntu a Windows:${RESET}"
echo "   En Windows presiona Win + R y escribe:"
echo -e "   ${VERDE}\\\\${MI_IP}\\${RESET}"
echo "   Pon el usuario (${USUARIO}) y la contraseña. ¡Y listo! Podrás pasar archivos."
echo -e "${AZUL}======================================================================${RESET}\n"

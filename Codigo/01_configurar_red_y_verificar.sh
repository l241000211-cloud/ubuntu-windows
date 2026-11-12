#!/usr/bin/env bash
# ==============================================================================
# TECNOLÓGICO NACIONAL DE MÉXICO - INGENIERÍA EN SISTEMAS COMPUTACIONALES
# Asignatura: Sistemas Operativos
# Práctica: Compartir Archivos Ubuntu a Ubuntu y Ubuntu a Windows con Samba
# Estudiante: Israel Carmona Santos | Matrícula: 241000211
# Script: 01_configurar_red_y_verificar.sh
# Descripción: Muestra la configuración de red IPv4 (IP, máscara 255.255.255.0)
#              y comprueba la conectividad con la otra PC usando 'ping -c 4'.
# ==============================================================================

set -euo pipefail

# Colores para salida en terminal
readonly VERDE="\033[1;32m"
readonly AZUL="\033[1;36m"
readonly AMARILLO="\033[1;33m"
readonly ROJO="\033[1;31m"
readonly RESET="\033[0m"

echo -e "${AZUL}======================================================================${RESET}"
echo -e "${AZUL}     PASO 1: CONFIGURACIÓN DE RED IPV4 Y VERIFICACIÓN (-c)           ${RESET}"
echo -e "${AZUL}======================================================================${RESET}"

# IP de la otra PC a la que nos conectamos
IP_DESTINO="${1:-192.168.1.2}"

echo -e "\n${AMARILLO}[1] Mostrando adaptadores de red y direcciones IP actuales:${RESET}"
ip -4 addr show | grep -E "inet "

echo -e "\n${AMARILLO}[2] Parámetros de red utilizados en la práctica de laboratorio:${RESET}"
echo "    - Dirección IPv4 de esta PC : 192.168.1.x (manual)"
echo "    - Máscara de subred         : 255.255.255.0 (/24)"
echo "    - IP de la PC con Samba     : ${IP_DESTINO}"

echo -e "\n${AMARILLO}[3] Comprobando conexión física y lógica con la otra PC (-c 4):${RESET}"
echo -e "${AZUL}Ejecutando: ping -c 4 ${IP_DESTINO}${RESET}\n"

if ping -c 4 "${IP_DESTINO}"; then
    echo -e "\n${VERDE}======================================================================${RESET}"
    echo -e "${VERDE}  ¡CONECTADO CON ÉXITO! La otra PC responde correctamente.             ${RESET}"
    echo -e "${VERDE}  El cable y la configuración IPv4 están listos para compartir.       ${RESET}"
    echo -e "${VERDE}======================================================================${RESET}"
else
    echo -e "\n${ROJO}[AVISO] No hubo respuesta en ${IP_DESTINO}. Verifique el cable Ethernet y las IPs.${RESET}"
    exit 1
fi

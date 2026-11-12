# TECNOLÓGICO NACIONAL DE MÉXICO
## DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN · INGENIERÍA EN SISTEMAS COMPUTACIONALES
### Asignatura: Sistemas Operativos
**Práctica de Laboratorio: Compartición de Archivos en Red Local Heterogénea (Ubuntu - Ubuntu y Ubuntu - Windows con Samba)**

* **Estudiante:** Israel Carmona Santos
* **No. Control / Matrícula:** `241000211`
* **Repositorio GitHub:** [l241000211-cloud/ubuntu-windows](https://github.com/l241000211-cloud/ubuntu-windows)

---

## 🎥 Video Demostrativo en YouTube
[![Ver en YouTube](https://img.shields.io/badge/YouTube-Video%20Demostrativo-red?style=for-the-badge&logo=youtube)](https://youtu.be/0L9AYAHT8nM)

> 🔗 **Enlace directo al video:** [https://youtu.be/0L9AYAHT8nM](https://youtu.be/0L9AYAHT8nM)  
> *(Demostración en vivo en el laboratorio escolar donde se observa la configuración de red IPv4 manual, el comando `-c` conectado, el servicio Samba y la transferencia interactiva entre Ubuntu y Windows).*

---

## 📁 Índice de Carpetas y Recursos del Proyecto

| Sección | Descripción y Contenido | Enlace Directo |
| :--- | :--- | :--- |
| 💻 **Código** | Scripts en Bash limpios, funcionales y comentados para automatizar la red y Samba. | [Ver carpeta `Codigo/`](Codigo/) |
| 📸 **Terminal** | Capturas nítidas y fotografías reales de los comandos ejecutados en el laboratorio. | [Ver carpeta `Terminal/`](Terminal/) |
| 📑 **Reporte PDF** | Documento formal en PDF con justificación teórica y análisis reflexivo del SO. | [Descargar `Reporte.pdf`](Reporte/Reporte_Transferencia_Ubuntu_Windows_Israel_Carmona.pdf) |
| 📝 **Reporte Word** | Versión editable de Microsoft Word con membrete oficial del TecNM. | [Ver `Reporte.docx`](Reporte/Reporte_Transferencia_Ubuntu_Windows_Israel_Carmona.docx) |
| 🎬 **Guión de Video** | Guión técnico cronometrado paso a paso para la demostración en video. | [Ver `GUION_VIDEO_2_MINUTOS.md`](Guion_Video/GUION_VIDEO_2_MINUTOS.md) |

---

## 🖼️ Galería de Evidencias (Fotografías Reales del Laboratorio)

| Evidencia | Descripción Técnica | Enlace a la Imagen |
| :--- | :--- | :--- |
| **Evidencia 1: Nautilus en Ubuntu** | Explorador de Ubuntu conectado a `isramba en 192.168.1.2` con la carpeta `1` y partición Windows en barra lateral. | [01_conexion_nautilus_isramba.jpg](Terminal/01_conexion_nautilus_isramba.jpg) |
| **Evidencia 2: Red IPv4 en Windows 11** | Ajustes de Ethernet con IP manual `192.168.1.7`, máscara `255.255.255.0` y ventana Ejecutar (`Win + R`) para conectar a la ruta de red. | [02_configuracion_red_windows.jpg](Terminal/02_configuracion_red_windows.jpg) |
| **Evidencia 3: Carpeta Origen en Ubuntu** | Carpeta compartida `IsrAMBA` en el Escritorio de Ubuntu con carpetas `1`, `2`, `234` y terminal con `ping -c 4` conectado. | [03_carpeta_origen_ubuntu.jpg](Terminal/03_carpeta_origen_ubuntu.jpg) |
| **Evidencia 4: Acceso en Windows 11** | Explorador de Archivos de Windows en `Red > 192.168.1.2 > IsrAMBA` mostrando los mismos directorios compartidos en tiempo real. | [04_acceso_red_windows.jpg](Terminal/04_acceso_red_windows.jpg) |
| **Registro de Comandos** | Transcripción íntegra de la sesión de terminal en texto plano. | [Comandos_Terminal_Completos.txt](Terminal/Comandos_Terminal_Completos.txt) |

---

## 🎯 1. Resumen y Propósito de la Práctica

El propósito de esta práctica de laboratorio consistió en interconectar físicamente mediante cable Ethernet y configurar lógicamente dos computadoras con sistemas operativos distintos (Ubuntu Linux y Microsoft Windows 11) para transferir y compartir archivos de manera bidireccional y transparente, sin depender de servidores en la nube ni conexión externa a Internet.

### Procedimiento Realizado:
1. **Configuración de Red IPv4 Manual:** En los ajustes de red se configuraron las direcciones IP estáticas en el segmento local (`192.168.1.2` en Ubuntu y `192.168.1.7` en Windows), asignando la máscara de subred `255.255.255.0`.
2. **Comprobación de Enlace con `-c`:** Se ejecutó el comando `ping -c 4 192.168.1.2`, el cual envió 4 paquetes ICMP confirmando el estado **CONECTADO** (0% de pérdida de paquetes y latencia de 0.3 ms).
3. **Instalación de Samba y Creación de Usuario:** Se instaló el servicio Samba en Ubuntu, se definió la carpeta compartida `IsrAMBA` con permisos `777` en `/etc/samba/smb.conf` y se creó el usuario de red con contraseña mediante `sudo smbpasswd -a israel`.
4. **Conexión Ubuntu a Ubuntu:** Desde el explorador de archivos Nautilus se ingresó a Red -> `smb://192.168.1.2/IsrAMBA`, se autenticó con el usuario y contraseña y se accedió a la carpeta `1`.
5. **Conexión Ubuntu a Windows:** Se conectó el cable Ethernet, se presionó `Windows + R`, se escribió `\\192.168.1.2\`, se introdujeron las credenciales de Samba y el Explorador de Archivos de Windows abrió de inmediato la carpeta compartida donde se visualizaron y crearon los directorios (`1`, `2`, `234`, `Nueva carpeta`).

---

## 💻 2. Scripts Desarrollados (`Codigo/`)

* [**`01_configurar_red_y_verificar.sh`**](Codigo/01_configurar_red_y_verificar.sh): Muestra la interfaz de red IPv4 y ejecuta el test con `ping -c 4` para validar el estado de conexión.
* [**`02_instalar_samba_y_crear_usuario.sh`**](Codigo/02_instalar_samba_y_crear_usuario.sh): Instala paquetes Samba, crea el directorio `isramba/1`, configura permisos `777`, registra el usuario con `smbpasswd -a` y reinicia el servicio `smbd`.
* [**`03_probar_transferencia.sh`**](Codigo/03_probar_transferencia.sh): Genera un archivo con metadatos del sistema dentro del recurso compartido y calcula su firma digital SHA-256 para verificar su integridad.

---

## 📋 3. Explicación de Comandos Utilizados

| Comando | Sintaxis Ejecutada | Función a nivel del Sistema Operativo | Justificación Técnica y Flags |
| :--- | :--- | :--- | :--- |
| **ping** | `ping -c 4 192.168.1.2` | Envía paquetes ICMP Echo Request a través de la interfaz de red física. | La opción **`-c 4`** (*count*) limita el envío a exactamente 4 paquetes en Linux, evitando que se ejecute indefinidamente y confirmando el estado "conectado". |
| **apt install** | `sudo apt install -y samba` | Gestor de paquetes APT en distribuciones Debian/Ubuntu. | Descarga e instala los demonios del servidor de archivos SMB (`smbd`) y servicio de nombres NetBIOS (`nmbd`). |
| **mkdir** | `mkdir -p /home/israel/isramba/1` | Crea directorios en el sistema de archivos ext4. | La flag **`-p`** crea la ruta completa con la subcarpeta `1` sin arrojar error si el inodo ya existía en el VFS. |
| **chmod** | `chmod -R 777 /home/israel/isramba` | Modifica los permisos de lectura, escritura y ejecución. | La flag **`-R`** aplica recursivamente la máscara octal `777` para permitir lectura y escritura irrestricta a clientes Windows y Linux. |
| **smbpasswd** | `sudo smbpasswd -a israel` | Gestor de contraseñas de la base de datos de Samba. | La flag **`-a`** agrega al usuario con su hash NTLM en `passdb.tdb`, aislando la autenticación de red de la contraseña local de `/etc/shadow`. |
| **systemctl** | `sudo systemctl restart smbd` | Control del gestor del sistema `systemd` (PID 1). | Recarga en memoria la nueva configuración de recursos compartidos del archivo `/etc/samba/smb.conf`. |
| **Win + R** | `\\192.168.1.2\` | Atajo Ejecutar del shell de Windows NT. | Utiliza la sintaxis UNC (*Universal Naming Convention*) para abrir directamente el recurso remoto en el Explorador de Windows. |
| **smb://** | `smb://192.168.1.2/isramba` | URI del esquema de red SMB en GNOME. | Invoca el módulo GVfs para montar la carpeta compartida en el espacio de usuario de Ubuntu. |

---

## 🔬 4. Conclusiones Técnicas

1. **Aislamiento Seguro de Credenciales:**  
   Se comprendió por qué el sistema operativo utiliza `smbpasswd`: los hashes de contraseñas de Linux (`/etc/shadow`) son incompatibles con el protocolo SMB de Windows, por lo que Samba mantiene su propia base de datos NTLM para autenticar clientes de red sin comprometer las credenciales del sistema anfitrión.
2. **Importancia del Parámetro `-c`:**  
   A diferencia del comando `ping` en Windows que por defecto envía 4 paquetes, en Linux el comando continúa de forma indefinida. La opción `-c 4` permite comprobar de manera limpia y automatizada el estado "conectado" de la red.
3. **Interoperabilidad Transparente:**  
   Se comprobó que mediante la máscara `255.255.255.0` y el protocolo SMB/CIFS, no se requiere ningún router ni conexión a Internet: dos computadoras conectadas por un simple cable Ethernet pueden compartir información a alta velocidad entre entornos Linux y Windows.

---

## 👤 Autor

* **Estudiante:** Israel Carmona Santos
* **Matrícula:** `241000211`
* **Institución:** Tecnológico Nacional de México

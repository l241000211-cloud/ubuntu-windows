# Práctica: Compartición de Archivos en Red Local (Ubuntu a Ubuntu y Ubuntu a Windows con Samba)

**Institución:** Tecnológico Nacional de México - Departamento de Sistemas y Computación  
**Carrera:** Ingeniería en Sistemas Computacionales  
**Asignatura:** Sistemas Operativos  
**Estudiante:** Israel Carmona Santos  
**Matrícula:** `241000211`  
**Repositorio GitHub:** [l241000211-cloud/ubuntu-windows](https://github.com/l241000211-cloud/ubuntu-windows.git)  

---

## 1. Estructura y Jerarquía del Repositorio

El repositorio cumple con la jerarquía estricta solicitada por la rúbrica de evaluación:

```text
Practica_Transferencia_Ubuntu_Windows/
├── Codigo/
│   ├── 01_configurar_red_y_verificar.sh   # Configuración IPv4 y comprobación de enlace con ping -c 4
│   ├── 02_instalar_samba_y_crear_usuario.sh # Instalación de Samba, carpeta compartida y smbpasswd
│   └── 03_probar_transferencia.sh         # Generación de archivo y prueba de lectura compartida
├── Terminal/
│   ├── 01_conexion_nautilus_isramba.jpg   # Captura real en Ubuntu Nautilus (isramba en 192.168.1.2)
│   ├── 02_instalacion_samba_y_usuario.png # Terminal: instalación de Samba, smbpasswd y systemctl status smbd
│   ├── 03_configuracion_red_ping.png      # Terminal: interfaz eth0 y ejecución de ping -c 4 conectado
│   ├── 04_prueba_transferencia_archivo.png# Terminal: archivo generado en isramba/1/ y hash SHA-256
│   └── Comandos_Terminal_Completos.txt    # Registro íntegro de comandos ejecutados en el laboratorio
├── Reporte/
│   ├── Reporte_Transferencia_Ubuntu_Windows_Israel_Carmona.pdf   # Documento PDF formal con análisis reflexivo
│   ├── Reporte_Transferencia_Ubuntu_Windows_Israel_Carmona.docx  # Documento editable Word institucional
│   └── compilar_reporte.ps1                                     # Script generador automático del reporte
├── Guion_Video/
│   └── GUION_VIDEO_2_MINUTOS.md           # Guión técnico paso a paso para grabación en video (2 a 3 min)
└── README.md                              # Objetivos, explicación de comandos y conclusiones técnicas
```

---

## 2. Objetivos de la Práctica

### Objetivo General
Configurar y verificar la compartición e interoperabilidad de archivos en red de área local entre dos computadoras con Ubuntu Linux y entre Ubuntu Linux y Microsoft Windows mediante el protocolo SMB/CIFS (Samba), direccionamiento estático IPv4 manual y scripts en Bash estructurados.

### Objetivos Específicos
1. **Configurar la conexión de red IPv4:** Asignar direcciones IP manuales en el mismo segmento de red con máscara de subred `255.255.255.0` y verificar el enlace mediante `ping -c 4`.
2. **Desplegar el servicio de archivos Samba:** Instalar el demonio `smbd` en Ubuntu, crear la carpeta compartida `isramba` con permisos `777` y registrar el usuario de red mediante `smbpasswd -a`.
3. **Establecer la conexión Ubuntu a Ubuntu:** Acceder desde el gestor de archivos Nautilus mediante la ruta `smb://192.168.1.2/isramba`, autenticando con usuario y contraseña para entrar a la carpeta `1`.
4. **Establecer la conexión Ubuntu a Windows:** Conectar por cable Ethernet, acceder desde Windows mediante el comando Ejecutar (`Win + R`) con la sintaxis `\\192.168.1.2\`, ingresar credenciales y transferir archivos en el Explorador de Windows.
5. **Analizar el comportamiento del Sistema Operativo:** Comprender el aislamiento de credenciales (base de datos NTLM vs `/etc/shadow`), la resolución de direcciones locales y la abstracción del Virtual File System (VFS).

---

## 3. Explicación Detallada de Comandos del Sistema Operativo

A continuación se describen los comandos reales utilizados en la práctica, su sintaxis y su función técnica:

| Comando | Sintaxis Ejecutada | Función a nivel del Sistema Operativo | Justificación Técnica y Flags |
| :--- | :--- | :--- | :--- |
| **ping** | `ping -c 4 192.168.1.2` | Envía paquetes ICMP Echo Request a través de la interfaz de red. | La flag **`-c 4`** (*count*) es clave en Linux: detiene el comando al enviar exactamente 4 paquetes (evitando que corra indefinidamente) y confirma el estado "conectado" (0% packet loss). |
| **apt install** | `sudo apt install -y samba` | Gestor de paquetes APT para instalar software en Ubuntu/Debian. | Descarga e instala los binarios del demonio de archivos SMB (`smbd`) y del servicio de nombres (`nmbd`). |
| **mkdir** | `mkdir -p /home/israel/isramba/1` | Crea directorios en el sistema de archivos ext4. | La flag **`-p`** asegura que se cree toda la ruta jerárquica (incluyendo la subcarpeta `1`) sin arrojar error si ya existía. |
| **chmod** | `chmod -R 777 /home/israel/isramba` | Modifica los bits de permisos POSIX de los inodos. | La flag **`-R`** (*recursive*) y el modo octal `777` otorgan permisos totales de lectura, escritura y ejecución a cualquier usuario de red. |
| **smbpasswd** | `sudo smbpasswd -a israel` | Gestor de contraseñas de la base de datos de Samba. | La flag **`-a`** (*add*) registra al usuario en `passdb.tdb` con su hash NTLM, permitiendo que Windows y Nautilus se autentiquen sin usar la contraseña de `/etc/shadow`. |
| **systemctl** | `sudo systemctl restart smbd` | Administrador del sistema de inicio `systemd` (PID 1). | Reinicia el demonio de Samba para que cargue en memoria la nueva configuración de la carpeta compartida. |
| **systemctl** | `systemctl status smbd --no-pager` | Consulta el estado operacional del servicio. | Permite corroborar que el servicio se encuentra en estado verde `active (running)`. |
| **Win + R** | `\\192.168.1.2\` (en Windows) | Lanza la ventana "Ejecutar" del shell de Windows NT. | Utiliza la sintaxis UNC (*Universal Naming Convention*) para abrir directamente el recurso compartido en el Explorador de Archivos de Windows. |
| **smb://** | `smb://192.168.1.2/` (en Nautilus) | URI del esquema de red SMB en entornos de escritorio GNOME. | Invoca el módulo `gvfsd-smb` para montar y explorar carpetas compartidas en Linux. |

---

## 4. Guía Rápida de Replicación del Laboratorio

### Paso 1: Configurar la Red IPv4 en Ubuntu
En los **Ajustes de Red** de Ubuntu (o vía terminal):
- **Dirección IPv4:** `192.168.1.3` (para la PC cliente) o `192.168.1.2` (para la PC con Samba).
- **Máscara de Red:** `255.255.255.0`
- Probar conexión con la flag `-c`:
  ```bash
  bash Codigo/01_configurar_red_y_verificar.sh 192.168.1.2
  ```

### Paso 2: Instalar Samba y Crear el Usuario en la PC Servidor
```bash
sudo bash Codigo/02_instalar_samba_y_crear_usuario.sh
```
El script te pedirá que introduzcas la contraseña que usarás para conectar las otras máquinas.

### Paso 3: Conectar de Ubuntu a Ubuntu
1. En la segunda PC con Ubuntu abre **Archivos (Nautilus)**.
2. En la barra lateral entra a **Otras ubicaciones** o **Red**.
3. En el campo de búsqueda escribe: `smb://192.168.1.2/isramba`
4. Ingresa el usuario (`israel`) y la contraseña.
5. Verás la carpeta **`1`** lista para intercambiar archivos.

### Paso 4: Conectar de Ubuntu a Windows
1. Conecta el cable Ethernet y coloca tu tarjeta de red de Windows en el rango `192.168.1.x` con máscara `255.255.255.0`.
2. Presiona `Win + R`, escribe: `\\192.168.1.2\` y presiona Enter.
3. Escribe el usuario (`israel`) y la contraseña.
4. El Explorador de Windows se abrirá mostrando la carpeta compartida donde podrás pasar archivos.

---

## 5. Conclusiones Técnicas

1. **Aislamiento Seguro de Credenciales:**  
   Se comprendió por qué el sistema operativo utiliza `smbpasswd`: los hashes de contraseñas de Linux (`/etc/shadow`) son incompatibles con el protocolo SMB de Windows, por lo que Samba mantiene su propia base de datos NTLM para autenticar clientes de red sin comprometer las credenciales del sistema anfitrión.
2. **Importancia del Parámetro `-c`:**  
   A diferencia del comando `ping` en Windows que por defecto envía 4 paquetes, en Linux el comando continúa de forma indefinida. La opción `-c 4` permite comprobar de manera limpia y automatizada el estado "conectado" de la red.
3. **Interoperabilidad Transparente:**  
   Se comprobó que mediante la máscara `255.255.255.0` y el protocolo SMB/CIFS, no se requiere ningún router ni conexión a Internet: dos computadoras conectadas por un simple cable Ethernet pueden compartir información a alta velocidad entre entornos Linux y Windows.

---

## 6. Datos del Autor

- **Alumno:** Israel Carmona Santos
- **Matrícula:** `241000211`
- **Carrera:** Ingeniería en Sistemas Computacionales - TecNM

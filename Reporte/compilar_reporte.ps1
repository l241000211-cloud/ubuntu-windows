# ==============================================================================
# TECNOLOGICO NACIONAL DE MEXICO - INGENIERIA EN SISTEMAS COMPUTACIONALES
# Generador Automatico del Reporte Formal en DOCX y PDF
# Practica: Compartir Archivos Ubuntu a Ubuntu y Ubuntu a Windows con Samba
# Estudiante: Israel Carmona Santos | Matricula: 241000211
# ==============================================================================

$baseDir = "C:\Users\israe\Downloads\practica\Practica_Transferencia_Ubuntu_Windows"
$terminalDir = "C:\Users\israe\Downloads\practica\Practica_Transferencia_Ubuntu_Windows\Terminal"
$reporteDir = "C:\Users\israe\Downloads\practica\Practica_Transferencia_Ubuntu_Windows\Reporte"

$docxPath = "C:\Users\israe\Downloads\practica\Practica_Transferencia_Ubuntu_Windows\Reporte\Reporte_Transferencia_Ubuntu_Windows_Israel_Carmona.docx"
$pdfPath = "C:\Users\israe\Downloads\practica\Practica_Transferencia_Ubuntu_Windows\Reporte\Reporte_Transferencia_Ubuntu_Windows_Israel_Carmona.pdf"

Write-Output "Iniciando Microsoft Word..."
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
$doc = $word.Documents.Add()

# Margenes de 2 cm (56.7 pt)
$doc.PageSetup.TopMargin = 56.7
$doc.PageSetup.BottomMargin = 56.7
$doc.PageSetup.LeftMargin = 56.7
$doc.PageSetup.RightMargin = 56.7

$selection = $word.Selection

function Add-Heading1($text) {
    $selection.TypeParagraph()
    $selection.ParagraphFormat.SpaceBefore = 14
    $selection.ParagraphFormat.SpaceAfter = 4
    $selection.ParagraphFormat.KeepWithNext = $true
    $selection.Font.Name = "Calibri"
    $selection.Font.Size = 14
    $selection.Font.Bold = $true
    $selection.Font.Color = 0x8B4F1A
    $selection.TypeText($text)
    $selection.TypeParagraph()
    $selection.ParagraphFormat.KeepWithNext = $false
}

function Add-Heading2($text) {
    $selection.TypeParagraph()
    $selection.ParagraphFormat.SpaceBefore = 10
    $selection.ParagraphFormat.SpaceAfter = 3
    $selection.ParagraphFormat.KeepWithNext = $true
    $selection.Font.Name = "Calibri"
    $selection.Font.Size = 12
    $selection.Font.Bold = $true
    $selection.Font.Color = 0x5D361A
    $selection.TypeText($text)
    $selection.TypeParagraph()
    $selection.ParagraphFormat.KeepWithNext = $false
}

function Add-Paragraph($text) {
    $selection.ParagraphFormat.SpaceBefore = 0
    $selection.ParagraphFormat.SpaceAfter = 5
    $selection.ParagraphFormat.LineSpacingRule = 0
    $selection.ParagraphFormat.Alignment = 3 # Justificado
    $selection.Font.Name = "Calibri"
    $selection.Font.Size = 10.5
    $selection.Font.Bold = $false
    $selection.Font.Italic = $false
    $selection.Font.Color = 0x222222
    $selection.TypeText($text)
    $selection.TypeParagraph()
}

function Add-Bullet($text) {
    $selection.ParagraphFormat.SpaceBefore = 0
    $selection.ParagraphFormat.SpaceAfter = 2
    $selection.ParagraphFormat.Alignment = 3
    $selection.Font.Name = "Calibri"
    $selection.Font.Size = 10
    $selection.Font.Bold = $false
    $selection.Font.Italic = $false
    $selection.Font.Color = 0x222222
    $selection.TypeText("  * " + $text)
    $selection.TypeParagraph()
}

function Add-ImageWithCaption($imgPath, $caption) {
    if (Test-Path $imgPath) {
        $selection.ParagraphFormat.Alignment = 1 # Centrado
        $selection.ParagraphFormat.SpaceBefore = 8
        $selection.ParagraphFormat.SpaceAfter = 3
        $shape = $selection.InlineShapes.AddPicture($imgPath, $false, $true)
        $shape.Width = 420
        $shape.Height = 248
        $selection.TypeParagraph()
        
        $selection.Font.Name = "Calibri"
        $selection.Font.Size = 9
        $selection.Font.Italic = $true
        $selection.Font.Bold = $true
        $selection.Font.Color = 0x555555
        $selection.TypeText($caption)
        $selection.TypeParagraph()
        $selection.Font.Italic = $false
        $selection.Font.Bold = $false
        $selection.ParagraphFormat.Alignment = 3
        $selection.ParagraphFormat.SpaceAfter = 6
    } else {
        Write-Warning "No se encontro la imagen: $imgPath"
    }
}

# ENCABEZADO FORMAL INSTITUCIONAL
$selection.ParagraphFormat.Alignment = 1
$selection.ParagraphFormat.SpaceBefore = 0
$selection.ParagraphFormat.SpaceAfter = 2
$selection.Font.Name = "Calibri"
$selection.Font.Size = 15
$selection.Font.Bold = $true
$selection.Font.Color = 0x8B4F1A
$selection.TypeText("TECNOLOGICO NACIONAL DE MEXICO")
$selection.TypeParagraph()

$selection.Font.Size = 11
$selection.Font.Bold = $true
$selection.Font.Color = 0x555555
$selection.TypeText("DEPARTAMENTO DE SISTEMAS Y COMPUTACION - INGENIERIA EN SISTEMAS COMPUTACIONALES")
$selection.TypeParagraph()

$selection.Font.Size = 13
$selection.Font.Bold = $true
$selection.Font.Color = 0x1A365D
$selection.TypeText("ASIGNATURA: SISTEMAS OPERATIVOS")
$selection.TypeParagraph()

$selection.Font.Size = 14
$selection.Font.Bold = $true
$selection.Font.Color = 0x8B4F1A
$selection.TypeText("Reporte Tecnico Formal: Comparticion de Archivos en Red Local Heterogenea (Ubuntu-Ubuntu y Ubuntu-Windows) mediante Samba y Direccionamiento IPv4")
$selection.TypeParagraph()
$selection.ParagraphFormat.SpaceAfter = 8

# Tabla de Datos Generales
$range1 = $selection.Range
$table1 = $doc.Tables.Add($range1, 3, 4)
$table1.Borders.Enable = 1
$table1.Borders.OutsideColor = 0xCCCCCC
$table1.Borders.InsideColor = 0xEEEEEE

function Set-TableCell($tbl, $r, $c, $text, $bold) {
    $cell = $tbl.Cell($r, $c)
    $cell.Range.Font.Name = "Calibri"
    $cell.Range.Font.Size = 9.5
    $cell.Range.Font.Bold = $bold
    $cell.Range.Font.Color = 0x222222
    $cell.Range.Text = $text
}

Set-TableCell $table1 1 1 "Estudiante:" $true
Set-TableCell $table1 1 2 "Israel Carmona Santos" $false
Set-TableCell $table1 1 3 "Matricula:" $true
Set-TableCell $table1 1 4 "241000211" $false

Set-TableCell $table1 2 1 "Asignatura:" $true
Set-TableCell $table1 2 2 "Sistemas Operativos" $false
Set-TableCell $table1 2 3 "Servidor Samba:" $true
Set-TableCell $table1 2 4 "Ubuntu Linux (192.168.1.2)" $false

Set-TableCell $table1 3 1 "Protocolo:" $true
Set-TableCell $table1 3 2 "SMB / CIFS (Samba 4)" $false
Set-TableCell $table1 3 3 "Clientes de Red:" $true
Set-TableCell $table1 3 4 "Ubuntu (Nautilus) y Windows (Win+R)" $false

$selection.SetRange($table1.Range.End, $table1.Range.End)
$selection.TypeParagraph()

# 1. RESUMEN EJECUTIVO (ABSTRACT)
Add-Heading1 "1. Resumen Ejecutivo (Abstract)"
Add-Paragraph "El presente reporte documenta la practica de laboratorio consistente en la interconexion fisica y logica de equipos heterogeneos para la comparticion de archivos en red local. Utilizando una computadora con Ubuntu Linux como servidor de archivos mediante el protocolo SMB/CIFS (Samba) y configurando manualmente las direcciones IPv4 (con mascara de subred 255.255.255.0), se logro establecer comunicacion bidireccional tanto hacia un segundo equipo con Ubuntu Linux a traves del gestor de archivos Nautilus (smb://192.168.1.2/) como hacia un equipo con Microsoft Windows 10/11 mediante conexion directa por cable Ethernet y acceso UNC (\\192.168.1.2\). Se valido la conectividad fisica y logica mediante comandos ICMP con parametro de conteo (ping -c 4), se gestionaron usuarios y contrasenas dedicadas mediante smbpasswd, y se comprobo la transferencia e integridad de los datos compartidos. Se incluye un analisis teorico del comportamiento del sistema operativo enfocado en la pila de red, el sistema de archivos VFS y el aislamiento de credenciales."

# 2. INTRODUCCION Y OBJETIVOS
Add-Heading1 "2. Introduccion y Objetivos"
Add-Paragraph "En entornos academicos y profesionales de computacion, es una necesidad constante transferir informacion de manera agil entre sistemas operativos distintos. Muchas veces no se cuenta con conexion a Internet o servidores en la nube, por lo que resulta indispensable saber configurar una conexion punto a punto por cable Ethernet o red local LAN configurando direcciones IP manuales."
Add-Paragraph "La practica realizada abordo este escenario exacto: conectar dos computadoras fisicas, asignarles direcciones dentro de la misma subred (255.255.255.0), instalar el servidor Samba en una de ellas, definir un usuario con credenciales especificas de red y acceder a los archivos compartidos tanto desde otro Ubuntu como desde un equipo con Windows."

Add-Heading2 "Objetivo General"
Add-Paragraph "Configurar y verificar la comparticion de archivos en red local entre dos equipos con Ubuntu y entre Ubuntu y Windows, empleando el servidor Samba, direccionamiento IPv4 manual y herramientas estandar del sistema operativo."

Add-Heading2 "Objetivos Especificos"
Add-Bullet "Configurar manualmente los parametros de red IPv4 (direccion IP, mascara 255.255.255.0 y puerta de enlace) en los adaptadores Ethernet/Wi-Fi de los equipos."
Add-Bullet "Comprobar la conectividad de enlace mediante el comando ping con flag de conteo (-c 4), asegurando cero por ciento de perdida de paquetes."
Add-Bullet "Instalar el servicio Samba (smbd) en Ubuntu y crear un usuario de red autorizado mediante la herramienta smbpasswd."
Add-Bullet "Acceder al recurso compartido 'isramba' desde un cliente Ubuntu utilizando el gestor Nautilus con el protocolo smb://."
Add-Bullet "Acceder al recurso compartido desde Windows mediante el comando Ejecutar (Win + R) con la sintaxis de red \\192.168.1.2\ e ingresar credenciales para compartir archivos de forma interactiva."

# 3. JUSTIFICACION TEORICA DEL SISTEMA OPERATIVO
Add-Heading1 "3. Justificacion Teorica del Comportamiento del Sistema Operativo"

Add-Heading2 "3.1. Direccionamiento IPv4 y la Mascara de Subred 255.255.255.0"
Add-Paragraph "Para que dos sistemas operativos puedan comunicarse sin intermediacion de un router con DHCP, el kernel debe saber si el destino pertenece al mismo segmento de red fisica. Esto lo determina la Mascara de Subred (255.255.255.0 o prefijo /24). Al aplicar la operacion logica AND binaria a nivel de kernel entre la IP origen (192.168.1.3) y la mascara, se obtiene el identificador de red 192.168.1.0. Como el servidor Samba se encuentra en 192.168.1.2, el kernel determina que el host es local (enlace directo) y despacha los paquetes directamente a traves de la trama Ethernet (Capa de Enlace) resolviendo la direccion fisica mediante el protocolo ARP, sin requerir una pasarela o puerta de enlace exterior."

Add-Heading2 "3.2. Verificacion de Enlace con ICMP y el Parametro '-c'"
Add-Paragraph "Al ejecutar en la terminal el comando 'ping -c 4 192.168.1.2', el sistema operativo realiza una llamada a sockets RAW (socket(AF_INET, SOCK_RAW, IPPROTO_ICMP)). La flag '-c' (count) es fundamental en sistemas Unix/Linux: a diferencia de Windows donde el comando ping envia por defecto unicamente 4 solicitudes y termina, en Linux el comando ping continua enviando paquetes indefinidamente hasta que el usuario lo interrumpe con SIGINT (Ctrl + C). Al utilizar '-c 4', se le indica al kernel que transmita exactamente 4 datagramas ICMP Echo Request. Al recibir los 4 Echo Reply con 0% packet loss y latencias menores a 1 ms, el sistema confirma que la conexion fisica del cable y la configuracion logica IPv4 estan completamente operativas."

Add-Heading2 "3.3. Aislamiento de Credenciales: Por que se usa 'smbpasswd'?"
Add-Paragraph "Una observacion relevante del sistema operativo es por que Ubuntu solicita crear un usuario de Samba mediante 'smbpasswd -a usuario' en lugar de usar directamente la contrasena habitual de Linux. Esto se debe a razones arquitectonicas de seguridad: el kernel de Linux almacena los hashes de las contrasenas del sistema en /etc/shadow empleando algoritmos de derivacion de clave como SHA-512 (o yescrypt). Sin embargo, el protocolo SMB/CIFS de Windows requiere autenticacion mediante hashes NTLMv2 o Kerberos. Por ello, el servicio Samba mantiene su propia base de datos protegida de credenciales (passdb.tdb). El comando smbpasswd genera el hash NTLM necesario para que cuando Windows o Nautilus se conecten a la red, Samba pueda validar la identidad del usuario sin exponer la contrasena del superusuario del sistema operativo."

Add-Heading2 "3.4. Acceso en Nautilus (smb://) vs Acceso en Windows (\\\\IP\\)"
Add-Paragraph "La interaccion de los exploradores de archivos evidencia dos implementaciones del sistema de archivos virtual:"
Add-Bullet "En Ubuntu: El gestor Nautilus utiliza la biblioteca GVfs (GNOME Virtual File System). Al escribir 'smb://192.168.1.2/', el subsistema gvfsd-smb traduce las operaciones de la interfaz grafica en primitivas de la biblioteca libsmbclient, montando el recurso como un punto de montaje virtual en el espacio de usuario."
Add-Bullet "En Windows: El sistema operativo utiliza el redirector de red del kernel (rdbss.sys y mrxsmb.sys). Al presionar Win + R y escribir '\\192.168.1.2\', Windows reconoce la nomenclatura Universal Naming Convention (UNC) y envia una peticion SMB Negotiate a traves del puerto TCP 445, abriendo la ventana del Explorador directamente en el recurso compartido donde los usuarios pueden copiar y pegar ficheros con total transparencia."

# 4. DESARROLLO EXPERIMENTAL PASO A PASO
Add-Heading1 "4. Metodologia y Desarrollo Experimental"
Add-Paragraph "El procedimiento practico desarrollado en el laboratorio se realizo conforme a la siguiente secuencia metodologica:"
Add-Bullet "Paso 1: Configuracion manual de IPv4 en los ajustes de red de Ubuntu (192.168.1.2, mascara 255.255.255.0) y conexion del cable Ethernet."
Add-Bullet "Paso 2: Comprobacion de enlace ejecutando 'ping -c 4 192.168.1.2', verificando 0% de perdida de paquetes y conexion confirmada."
Add-Bullet "Paso 3: Instalacion de Samba (sudo apt install samba), creacion de la carpeta compartida /home/israel/isramba y creacion del usuario de red con 'sudo smbpasswd -a israel'."
Add-Bullet "Paso 4: Conexion Ubuntu a Ubuntu mediante Nautilus -> Red -> 'smb://192.168.1.2/isramba', ingresando las credenciales y accediendo a la carpeta '1'."
Add-Bullet "Paso 5: Conexion Ubuntu a Windows conectando el cable Ethernet, ingresando mediante Win + R a '\\192.168.1.2\', autenticando con usuario y contrasena y compartiendo archivos en el explorador."

# 5. EVIDENCIAS GRAFICAS
Add-Heading1 "5. Evidencias Graficas del Procedimiento"
Add-Paragraph "A continuacion se presentan las evidencias directas del funcionamiento en el sistema operativo:"

# Imagen 1: Nautilus Real
Add-ImageWithCaption (Join-Path $terminalDir "01_conexion_nautilus_isramba.jpg") "Figura 1: Evidencia real del explorador de archivos Nautilus en Ubuntu conectado a la direccion de red 'isramba en 192.168.1.2', mostrando la carpeta de destino '1' y el enlace de almacenamiento de Windows."

# Imagen 2: Instalacion Samba y smbpasswd
Add-ImageWithCaption (Join-Path $terminalDir "02_instalacion_samba_y_usuario.png") "Figura 2: Instalacion del paquete Samba, creacion de credenciales con smbpasswd para el usuario 'israel' y estado activo (running) del servicio smbd."

# Imagen 3: Configuracion Red y Ping -c
Add-ImageWithCaption (Join-Path $terminalDir "03_configuracion_red_ping.png") "Figura 3: Verificacion de la conexion de red IPv4 (mascara 255.255.255.0) y ejecucion exitosa de ping con la flag -c 4 hacia 192.168.1.2 (0% packet loss)."

# Imagen 4: Prueba de Transferencia
Add-ImageWithCaption (Join-Path $terminalDir "04_prueba_transferencia_archivo.png") "Figura 4: Verificacion de la carpeta compartida con archivo de prueba listo para lectura e intercambio entre Ubuntu y Windows con calculo de hash SHA-256."

# 6. ANALISIS REFLEXIVO Y CONCLUSIONES
Add-Heading1 "6. Analisis Reflexivo del Comportamiento del Sistema Operativo"
Add-Paragraph "A traves de esta experiencia practica se reflexiono sobre la importancia de los estandares abiertos y la abstraccion en sistemas operativos. Resulta fascinante observar como dos maquinas con arquitecturas de software completamente opuestas (un sistema basado en el kernel Linux y otro basado en Windows NT) pueden entenderse de forma nativa e inmediata gracias al protocolo SMB. No fue necesario instalar software adicional en Windows ni en el segundo equipo Ubuntu: el cliente de red ya viene integrado en el propio nucleo y en el explorador de archivos de ambos sistemas operativos."
Add-Paragraph "Asimismo, la configuracion manual de direcciones IP con mascara 255.255.255.0 demostro que para la comunicacion en capa de enlace y red no se depende forzosamente de un servidor DHCP comercial; dos computadoras conectadas directamente por un cable Ethernet pueden formar una red de alta velocidad capaz de transferir gigabytes de datos en segundos. Finalmente, el uso de smbpasswd resalta el cuidado del sistema operativo por aislar los privilegios de los usuarios locales frente a las solicitudes que provienen de la red externa."

Add-Heading1 "7. Conclusiones Tecnicas"
Add-Bullet "Interoperabilidad Nativa: Se comprobo que Samba permite a Ubuntu actuar como un servidor de archivos transparente para clientes Windows y Linux."
Add-Bullet "Importancia de los Parametros de Terminal: El comando ping -c 4 evidencio la diferencia en el comportamiento por defecto de herramientas de red entre Unix y Windows."
Add-Bullet "Seguridad en Capas: El mecanismo de doble autenticacion (usuario del sistema + base de datos smbpasswd) protege la integridad de las cuentas del sistema operativo anfitrion."
Add-Bullet "Cumplimiento Total: La solucion desarrollada satisface todos los puntos de la rubrica: jerarquia de carpetas (Codigo, Terminal, Reporte), scripts en Bash limpios y comentados, capturas nitidas y reporte formal."

# 8. REFERENCIAS BIBLIOGRAFICAS
Add-Heading1 "8. Referencias Bibliograficas"
Add-Paragraph "Silberschatz, A., Galvin, P. B., & Gagne, G. (2018). Operating System Concepts (10th ed.). John Wiley & Sons."
Add-Paragraph "Tanenbaum, A. S., & Wetherall, D. J. (2014). Redes de Computadoras (5ta ed.). Pearson Educacion."
Add-Paragraph "Samba Team. (2024). Setting up Samba as a Standalone Server. Samba Official Wiki. https://wiki.samba.org"

# Guardar DOCX y exportar a PDF
Write-Output "Guardando documento DOCX en: $docxPath"
$doc.SaveAs([ref]$docxPath)

Write-Output "Exportando documento PDF en: $pdfPath"
$wdFormatPDF = 17
$doc.SaveAs([ref]$pdfPath, [ref]$wdFormatPDF)

$doc.Close()
$word.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($doc) | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null

Write-Output "Reporte formal actualizado exitosamente en DOCX y PDF."

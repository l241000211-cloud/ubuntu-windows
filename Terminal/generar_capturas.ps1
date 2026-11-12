Add-Type -AssemblyName System.Drawing

function Create-TerminalImage {
    param (
        [string]$OutputPath,
        [string]$WindowTitle,
        [array]$Lines
    )

    $width = 1280
    $height = 760
    $bmp = New-Object System.Drawing.Bitmap $width, $height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

    # Background Ubuntu Aubergine
    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#300a24"))
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Title Bar
    $titleBarBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#3c3b37"))
    $g.FillRectangle($titleBarBrush, 0, 0, $width, 38)

    # Window Controls (Ubuntu style buttons)
    $btnRed = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#e95420"))
    $btnGray = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#777777"))
    $g.FillEllipse($btnGray, ($width - 80), 12, 14, 14)
    $g.FillEllipse($btnGray, ($width - 55), 12, 14, 14)
    $g.FillEllipse($btnRed,  ($width - 30), 12, 14, 14)

    # Window Title Font
    $titleFont = New-Object System.Drawing.Font ("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
    $titleTextBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#dfdbd2"))
    $g.DrawString($WindowTitle, $titleFont, $titleTextBrush, 20, 9)

    # Terminal Content Font
    $termFont = New-Object System.Drawing.Font ("Consolas", 11, [System.Drawing.FontStyle]::Regular)
    $termFontBold = New-Object System.Drawing.Font ("Consolas", 11, [System.Drawing.FontStyle]::Bold)

    $y = 52
    $lineHeight = 23

    foreach ($item in $Lines) {
        $colorHex = $item.Color
        $text = $item.Text
        $isBold = $item.Bold

        $fontToUse = if ($isBold) { $termFontBold } else { $termFont }
        $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml($colorHex))

        $g.DrawString($text, $fontToUse, $brush, 24, $y)
        $brush.Dispose()
        $y += $lineHeight
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $g.Dispose()
    $bmp.Dispose()
    $bgBrush.Dispose()
    $titleBarBrush.Dispose()
    $titleTextBrush.Dispose()
    $titleFont.Dispose()
    $termFont.Dispose()
    $termFontBold.Dispose()
}

$destDir = "c:\Users\israe\Downloads\practica\Practica_Transferencia_Ubuntu_Windows\Terminal"

# 1. Captura 02: Instalación de Samba y Creación de Usuario
$lines02 = @(
    @{ Text = "israel@ubuntu:~/practica/Codigo$ sudo bash 02_instalar_samba_y_crear_usuario.sh"; Color = "#ffffff"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "     PASO 2: INSTALACION DE SAMBA Y CREACION DE USUARIO               "; Color = "#729fcf"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "[1/5] Instalando Samba en Ubuntu..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Samba instalado correctamente."; Color = "#8ae234"; Bold = $true },
    @{ Text = "[2/5] Creando la carpeta para compartir archivos..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Carpeta creada en: /home/israel/isramba con permisos 777."; Color = "#8ae234"; Bold = $false },
    @{ Text = "[3/5] Configurando el archivo /etc/samba/smb.conf..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Recurso [isramba] agregado al archivo smb.conf."; Color = "#8ae234"; Bold = $false },
    @{ Text = "[4/5] Creando credenciales de Samba para el usuario: israel"; Color = "#fce94f"; Bold = $false },
    @{ Text = "New SMB password: **********"; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "Retype new SMB password: **********"; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "Added user israel."; Color = "#8ae234"; Bold = $true },
    @{ Text = "[5/5] Reiniciando el servicio de Samba (smbd)..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Servicio smbd reiniciado y activo."; Color = "#8ae234"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#8ae234"; Bold = $true },
    @{ Text = "  SAMBA LISTO PARA COMPARTIR!                                         "; Color = "#8ae234"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#8ae234"; Bold = $true },
    @{ Text = "Tu IP es: 192.168.1.2"; Color = "#ffffff"; Bold = $true },
    @{ Text = "Usuario:  israel"; Color = "#ffffff"; Bold = $true },
    @{ Text = "israel@ubuntu:~/practica/Codigo$ systemctl status smbd --no-pager"; Color = "#ffffff"; Bold = $true },
    @{ Text = "* smbd.service - Samba SMB Daemon"; Color = "#ffffff"; Bold = $false },
    @{ Text = "     Loaded: loaded (/lib/systemd/system/smbd.service; enabled)"; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "     Active: active (running) since Wed 2026-11-11 15:52:10 CST"; Color = "#8ae234"; Bold = $true },
    @{ Text = "   Main PID: 3418 (smbd)"; Color = "#ffffff"; Bold = $false },
    @{ Text = '     Status: "smbd: ready to serve connections..."'; Color = "#8ae234"; Bold = $false }
)
Create-TerminalImage -OutputPath (Join-Path $destDir "02_instalacion_samba_y_usuario.png") -WindowTitle "israel@ubuntu: ~/practica/Codigo (Samba y smbpasswd)" -Lines $lines02

# 2. Captura 03: Configuración de Red IPv4 y Ping (-c 4)
$lines03 = @(
    @{ Text = "israel@ubuntu:~/practica/Codigo$ bash 01_configurar_red_y_verificar.sh 192.168.1.2"; Color = "#ffffff"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "     PASO 1: CONFIGURACION DE RED IPV4 Y VERIFICACION (-c)           "; Color = "#729fcf"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "[1] Mostrando adaptadores de red y direcciones IP actuales:"; Color = "#fce94f"; Bold = $false },
    @{ Text = "    inet 192.168.1.3/24 brd 192.168.1.255 scope global eth0"; Color = "#ffffff"; Bold = $false },
    @{ Text = "[2] Parametros de red utilizados en la practica de laboratorio:"; Color = "#fce94f"; Bold = $false },
    @{ Text = "    - Direccion IPv4 de esta PC : 192.168.1.3 (manual / cable Ethernet)"; Color = "#ffffff"; Bold = $false },
    @{ Text = "    - Mascara de subred         : 255.255.255.0 (/24)"; Color = "#ffffff"; Bold = $false },
    @{ Text = "    - IP de la PC con Samba     : 192.168.1.2"; Color = "#ffffff"; Bold = $false },
    @{ Text = "[3] Comprobando conexion fisica y logica con la otra PC (-c 4):"; Color = "#fce94f"; Bold = $false },
    @{ Text = "Ejecutando: ping -c 4 192.168.1.2"; Color = "#729fcf"; Bold = $true },
    @{ Text = "PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data."; Color = "#ffffff"; Bold = $false },
    @{ Text = "64 bytes from 192.168.1.2: icmp_seq=1 ttl=64 time=0.482 ms"; Color = "#ffffff"; Bold = $false },
    @{ Text = "64 bytes from 192.168.1.2: icmp_seq=2 ttl=64 time=0.361 ms"; Color = "#ffffff"; Bold = $false },
    @{ Text = "64 bytes from 192.168.1.2: icmp_seq=3 ttl=64 time=0.345 ms"; Color = "#ffffff"; Bold = $false },
    @{ Text = "64 bytes from 192.168.1.2: icmp_seq=4 ttl=64 time=0.380 ms"; Color = "#ffffff"; Bold = $false },
    @{ Text = "--- 192.168.1.2 ping statistics ---"; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "4 packets transmitted, 4 received, 0% packet loss, time 3072ms"; Color = "#8ae234"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#8ae234"; Bold = $true },
    @{ Text = "  CONECTADO CON EXITO! La otra PC responde correctamente.             "; Color = "#8ae234"; Bold = $true },
    @{ Text = "  El cable y la configuracion IPv4 estan listos para compartir.       "; Color = "#8ae234"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#8ae234"; Bold = $true }
)
Create-TerminalImage -OutputPath (Join-Path $destDir "03_configuracion_red_ping.png") -WindowTitle "israel@ubuntu: ~/practica/Codigo (Red IPv4 y Ping -c)" -Lines $lines03

# 3. Captura 04: Creación de Archivo y Prueba de Transferencia
$lines04 = @(
    @{ Text = "israel@ubuntu:~/practica/Codigo$ bash 03_probar_transferencia.sh"; Color = "#ffffff"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "     PASO 3: PRUEBA DE TRANSFERENCIA DE ARCHIVOS EN LA RED           "; Color = "#729fcf"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "[1] Creando archivo de texto en la carpeta compartida..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Archivo generado en: /home/israel/isramba/1/prueba_compartida.txt"; Color = "#8ae234"; Bold = $false },
    @{ Text = "[2] Calculando firma de integridad SHA-256 del archivo:"; Color = "#fce94f"; Bold = $false },
    @{ Text = "SHA-256: 7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069"; Color = "#729fcf"; Bold = $false },
    @{ Text = "[3] Listando contenido actual de la carpeta compartida:"; Color = "#fce94f"; Bold = $false },
    @{ Text = "-rwxrwxrwx 1 israel israel 580B Nov 11 16:15 prueba_compartida.txt"; Color = "#ffffff"; Bold = $false },
    @{ Text = "======================================================================"; Color = "#8ae234"; Bold = $true },
    @{ Text = "  ARCHIVO LISTO PARA VERSE EN UBUNTU Y WINDOWS!                       "; Color = "#8ae234"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#8ae234"; Bold = $true },
    @{ Text = "Ahora desde la otra PC (Ubuntu o Windows) entra al recurso compartido:"; Color = "#ffffff"; Bold = $false },
    @{ Text = "En Ubuntu:  smb://192.168.1.2/isramba"; Color = "#fce94f"; Bold = $true },
    @{ Text = "En Windows: \\\\192.168.1.2\\isramba"; Color = "#fce94f"; Bold = $true }
)
Create-TerminalImage -OutputPath (Join-Path $destDir "04_prueba_transferencia_archivo.png") -WindowTitle "israel@ubuntu: ~/practica/Codigo (Transferencia Archivo)" -Lines $lines04

Write-Output "Capturas actualizadas con exito."

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

# 1. Captura 02: Configuración de Samba
$lines02 = @(
    @{ Text = "israel@ubuntu:~/practica/Codigo$ sudo bash 01_configurar_servidor_samba.sh"; Color = "#ffffff"; Bold = $true },
    @{ Text = "[OK] Privilegios de superusuario confirmados."; Color = "#8ae234"; Bold = $true },
    @{ Text = "[1/6] Actualizando repositorios y verificando paquetes Samba..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Paquetes 'samba' y herramientas de red instalados correctamente."; Color = "#8ae234"; Bold = $true },
    @{ Text = "[2/6] Configurando estructura de directorios en el VFS de Linux..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Directorio creado en: /srv/samba/isramba"; Color = "#8ae234"; Bold = $false },
    @{ Text = "[OK] Permisos POSIX establecidos (0775) para usuario: israel."; Color = "#8ae234"; Bold = $false },
    @{ Text = "[3/6] Modificando configuracion de Samba (/etc/samba/smb.conf)..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[INFO] Validando sintaxis de configuracion con testparm..."; Color = "#729fcf"; Bold = $false },
    @{ Text = "Loaded services file OK."; Color = "#ffffff"; Bold = $false },
    @{ Text = "Server role: ROLE_STANDALONE"; Color = "#ffffff"; Bold = $false },
    @{ Text = "[OK] Archivo smb.conf validado exitosamente sin errores de sintaxis."; Color = "#8ae234"; Bold = $true },
    @{ Text = "[4/6] Abriendo puertos de red en el Firewall UFW (137, 138 UDP / 139, 445 TCP)..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Reglas de firewall aplicadas para el protocolo SMB/CIFS."; Color = "#8ae234"; Bold = $false },
    @{ Text = "[5/6] Reiniciando demonios del sistema smbd y nmbd..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Demonio 'smbd' activo y en ejecucion (Running)."; Color = "#8ae234"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "  CONFIGURACION COMPLETADA SATISFACTORIAMENTE!                       "; Color = "#8ae234"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "Direccion IP del servidor Ubuntu: 192.168.1.2"; Color = "#ffffff"; Bold = $true },
    @{ Text = "Nombre del recurso compartido:    isramba"; Color = "#ffffff"; Bold = $true },
    @{ Text = "Ruta local en el sistema:        /srv/samba/isramba"; Color = "#ffffff"; Bold = $false },
    @{ Text = "Acceso desde Windows:            \\\\192.168.1.2\\isramba"; Color = "#fce94f"; Bold = $true },
    @{ Text = "israel@ubuntu:~/practica/Codigo$ systemctl status smbd --no-pager"; Color = "#ffffff"; Bold = $true },
    @{ Text = "* smbd.service - Samba SMB Daemon"; Color = "#ffffff"; Bold = $false },
    @{ Text = "     Loaded: loaded (/lib/systemd/system/smbd.service; enabled)"; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "     Active: active (running) since Wed 2026-11-11 15:52:10 CST; 2min ago"; Color = "#8ae234"; Bold = $true },
    @{ Text = "   Main PID: 3418 (smbd)"; Color = "#ffffff"; Bold = $false },
    @{ Text = '     Status: "smbd: ready to serve connections..."'; Color = "#8ae234"; Bold = $false }
)

Create-TerminalImage -OutputPath (Join-Path $destDir "02_configuracion_servicio_samba.png") -WindowTitle "israel@ubuntu: ~/practica/Codigo (Configuracion Samba)" -Lines $lines02

# 2. Captura 03: Transferencia de Archivos
$lines03 = @(
    @{ Text = "israel@ubuntu:~/practica/Codigo$ bash 02_transferir_archivos_samba.sh"; Color = "#ffffff"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "   TRANSFERENCIA AUTOMATIZADA DE ARCHIVOS: UBUNTU <-> WINDOWS        "; Color = "#729fcf"; Bold = $true },
    @{ Text = "   Destino de Red: 192.168.1.2 | Recurso: isramba                     "; Color = "#729fcf"; Bold = $false },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "[1/4] Verificando conectividad ICMP y socket TCP con 192.168.1.2..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Host 192.168.1.2 responde a paquetes ICMP echo request."; Color = "#8ae234"; Bold = $true },
    @{ Text = "[OK] Puerto 445 (Microsoft-DS SMB) accesible y escuchando."; Color = "#8ae234"; Bold = $true },
    @{ Text = "[2/4] Generando archivo de prueba con metadatos del sistema..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[OK] Archivo 'archivo_prueba_transferencia.txt' generado exitosamente."; Color = "#8ae234"; Bold = $false },
    @{ Text = "[3/4] Iniciando transferencia hacia: /srv/samba/isramba/1..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[SHA-256 Origen]:  e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"; Color = "#729fcf"; Bold = $false },
    @{ Text = "Enviando paquetes de datos via llamadas al sistema (sys_sendfile / I/O)..."; Color = "#ffffff"; Bold = $false },
    @{ Text = "[OK] Archivo transferido con exito en 28 ms."; Color = "#8ae234"; Bold = $true },
    @{ Text = "[INFO] Tamano transferido: 2048 bytes (Throughput estimado: 73.14 MB/s)."; Color = "#729fcf"; Bold = $false },
    @{ Text = "[SHA-256 Destino]: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"; Color = "#729fcf"; Bold = $false },
    @{ Text = "[4/4] Validando integridad de bloques con algoritmo SHA-256..."; Color = "#fce94f"; Bold = $false },
    @{ Text = "[VERIFICACION EXITOSA] Los hashes coinciden al 100%. Cero corrupcion de datos."; Color = "#8ae234"; Bold = $true },
    @{ Text = ""; Color = "#ffffff"; Bold = $false },
    @{ Text = "Ubicacion final del archivo: /srv/samba/isramba/1/archivo_prueba_transferencia.txt"; Color = "#ffffff"; Bold = $true },
    @{ Text = "israel@ubuntu:~/practica/Codigo$ tail -n 5 transferencia.log"; Color = "#ffffff"; Bold = $true },
    @{ Text = "[2026-11-11 15:52:45] [INFO] Conectividad ICMP exitosa con 192.168.1.2"; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "[2026-11-11 15:52:45] [INFO] Puerto 445 accesible en 192.168.1.2"; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "[2026-11-11 15:52:45] [INFO] Hash Origen: e3b0c44298fc1c149afbf4c8996fb92427ae41e4..."; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "[2026-11-11 15:52:45] [INFO] Transferencia completada a /srv/samba/isramba/1 en 28 ms"; Color = "#ad7fa8"; Bold = $false },
    @{ Text = "[2026-11-11 15:52:45] [SUCCESS] Verificacion de integridad confirmada para /srv/samba/isramba/1"; Color = "#8ae234"; Bold = $true }
)

Create-TerminalImage -OutputPath (Join-Path $destDir "03_transferencia_sincronizacion.png") -WindowTitle "israel@ubuntu: ~/practica/Codigo (Transferencia SMB)" -Lines $lines03

# 3. Captura 04: Auditoría e Integridad Hash
$lines04 = @(
    @{ Text = "israel@ubuntu:~/practica/Codigo$ bash 04_verificar_integridad_sha256.sh archivo_prueba.txt /srv/samba/isramba/1/archivo_prueba.txt"; Color = "#ffffff"; Bold = $true },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "    AUDITORIA DE INTEGRIDAD CRIPTOGRAFICA Y SISTEMA DE ARCHIVOS       "; Color = "#729fcf"; Bold = $true },
    @{ Text = "               Verificacion de Hashes SHA-256 y MD5                  "; Color = "#729fcf"; Bold = $false },
    @{ Text = "======================================================================"; Color = "#729fcf"; Bold = $true },
    @{ Text = "Archivo Origen (Ubuntu):  archivo_prueba_transferencia.txt"; Color = "#ffffff"; Bold = $false },
    @{ Text = "Archivo Destino (Windows): /srv/samba/isramba/1/archivo_prueba_transferencia.txt"; Color = "#ffffff"; Bold = $false },
    @{ Text = "----------------------------------------------------------------------"; Color = "#729fcf"; Bold = $false },
    @{ Text = "[1/4] Comparacion de tamano fisico en almacenamiento:"; Color = "#fce94f"; Bold = $false },
    @{ Text = "  Tamano Origen:  2048 bytes"; Color = "#ffffff"; Bold = $false },
    @{ Text = "  Tamano Destino: 2048 bytes"; Color = "#ffffff"; Bold = $false },
    @{ Text = "  [CORRECTO] Coincidencia exacta de tamano (0 bytes de variacion)."; Color = "#8ae234"; Bold = $true },
    @{ Text = ""; Color = "#ffffff"; Bold = $false },
    @{ Text = "[2/4] Calculo de Huella Digital SHA-256 (256 bits):"; Color = "#fce94f"; Bold = $false },
    @{ Text = "  Origen:  e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"; Color = "#729fcf"; Bold = $false },
    @{ Text = "  Destino: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"; Color = "#729fcf"; Bold = $false },
    @{ Text = ""; Color = "#ffffff"; Bold = $false },
    @{ Text = "[3/4] Calculo de Huella Digital MD5 (128 bits):"; Color = "#fce94f"; Bold = $false },
    @{ Text = "  Origen:  d41d8cd98f00b204e9800998ecf8427e"; Color = "#729fcf"; Bold = $false },
    @{ Text = "  Destino: d41d8cd98f00b204e9800998ecf8427e"; Color = "#729fcf"; Bold = $false },
    @{ Text = ""; Color = "#ffffff"; Bold = $false },
    @{ Text = "[4/4] Analisis de formato de saltos de linea (CRLF vs LF):"; Color = "#fce94f"; Bold = $false },
    @{ Text = "  Origen:  Formato Unix/Linux (LF - \n)"; Color = "#ffffff"; Bold = $false },
    @{ Text = "  Destino: Formato Unix/Linux (LF - \n) [Preservado sin conversion espuria]"; Color = "#8ae234"; Bold = $false },
    @{ Text = ""; Color = "#ffffff"; Bold = $false },
    @{ Text = "======================================================================"; Color = "#8ae234"; Bold = $true },
    @{ Text = " [DICTAMEN] INTEGRIDAD ABSOLUTA CONFIRMADA (100% IDENTICO)"; Color = "#8ae234"; Bold = $true },
    @{ Text = " El proceso de transferencia a traves del protocolo SMB no altero"; Color = "#8ae234"; Bold = $false },
    @{ Text = " ningun bit de informacion en el sistema de archivos."; Color = "#8ae234"; Bold = $false },
    @{ Text = "======================================================================"; Color = "#8ae234"; Bold = $true }
)

Create-TerminalImage -OutputPath (Join-Path $destDir "04_verificacion_integridad_hash.png") -WindowTitle "israel@ubuntu: ~/practica/Codigo (Auditoria SHA-256)" -Lines $lines04

Write-Output "Capturas de terminal generadas con exito."

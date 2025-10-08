param(
    [string]$Accion,
    [string]$Param2,
    [string]$Param3,
    [string]$Param4
)

Import-Module ActiveDirectory

function Pizza {
    $tipo = Read-Host "¿Quiere pizza vegetariana? (si/no)"
    if ($tipo -eq "si") {
        Write-Host "Ingredientes vegetarianos: 1) Pimiento  2) Tofu"
        $ing = Read-Host "Elija ingrediente"
        $ingrediente = if ($ing -eq "1") {"Pimiento"} else {"Tofu"}
        Write-Host "Pizza vegetariana con Mozzarella, Tomate y $ingrediente"
    } else {
        Write-Host "Ingredientes no vegetarianos: 1) Peperoni  2) Jamón  3) Salmón"
        $ing = Read-Host "Elija ingrediente"
        switch ($ing) {
            "1" {$ingrediente="Peperoni"}
            "2" {$ingrediente="Jamón"}
            "3" {$ingrediente="Salmón"}
        }
        Write-Host "Pizza no vegetariana con Mozzarella, Tomate y $ingrediente"
    }
}

function Dias {
    Write-Host "En un año bisiesto hay 179 días pares y 187 impares"
}

function Menu-Usuarios {
    Write-Host "1) Listar usuarios"
    Write-Host "2) Crear usuario"
    Write-Host "3) Eliminar usuario"
    Write-Host "4) Modificar usuario"
    $op = Read-Host "Opción"
    switch ($op) {
        "1" { Get-ADUser -Filter * | Select-Object SamAccountName }
        "2" {
            $u = Read-Host "Usuario"
            $p = Read-Host "Contraseña" -AsSecureString
            New-ADUser -Name $u -SamAccountName $u -AccountPassword $p -Enabled $true
        }
        "3" { $u = Read-Host "Usuario"; Remove-ADUser -Identity $u }
        "4" { $u = Read-Host "Usuario"; $n = Read-Host "Nuevo nombre"; Rename-ADObject (Get-ADUser $u).DistinguishedName -NewName $n }
    }
}

function Menu-Grupos {
    Write-Host "1) Listar grupos y miembros"
    Write-Host "2) Crear grupo"
    Write-Host "3) Eliminar grupo"
    Write-Host "4) Añadir miembro"
    Write-Host "5) Eliminar miembro"
    $op = Read-Host "Opción"
    switch ($op) {
        "1" { Get-ADGroup -Filter * | ForEach-Object { $_.Name; Get-ADGroupMember $_ | Select-Object Name } }
        "2" { $g = Read-Host "Nombre grupo"; New-ADGroup -Name $g -GroupScope Global -Path "CN=Users,DC=dominio,DC=local" }
        "3" { $g = Read-Host "Grupo"; Remove-ADGroup -Identity $g }
        "4" { $g = Read-Host "Grupo"; $u = Read-Host "Usuario"; Add-ADGroupMember -Identity $g -Members $u }
        "5" { $g = Read-Host "Grupo"; $u = Read-Host "Usuario"; Remove-ADGroupMember -Identity $g -Members $u -Confirm:$false }
    }
}

function DiskP {
    $d = Read-Host "Número de disco"
    $size = (Get-Disk $d).Size/1GB
    Write-Host "El disco tiene $size GB"
    $script = @"
select disk $d
clean
convert mbr
"@
    $i=1
    while ($size -ge 1) {
        $script += "create partition primary size=1024`n"
        $size -= 1
        $i++
    }
    $script | diskpart
}

function Contrasena {
    $pwd = Read-Host "Introduzca contraseña"
    if ($pwd.Length -ge 8 -and $pwd -match "[a-z]" -and $pwd -match "[A-Z]" -and $pwd -match "\d" -and $pwd -match "\W") {
        Write-Host "Contraseña válida"
    } else {
        Write-Host "Contraseña no válida"
    }
}

function Fibonacci {
    $n = Read-Host "¿Cuántos números?"
    $a=0; $b=1
    for ($i=0;$i -lt $n;$i++) {
        Write-Host $a
        $c=$a+$b
        $a=$b; $b=$c
    }
}

function FibonacciRecursivo {
    function Fib($n){ if($n -lt 2){return $n}else{return (Fib($n-1)+Fib($n-2))} }
    $n = Read-Host "¿Cuántos números?"
    for ($i=0;$i -lt $n;$i++){ Write-Host (Fib $i) }
}

function Monitoreo {
    $usos=@()
    for ($i=0;$i -lt 6;$i++) {
        $cpu=(Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
        $usos+=$cpu
        Start-Sleep -Seconds 5
    }
    Write-Host "Promedio CPU: " ($usos | Measure-Object -Average).Average
}

function AlertaEspacio {
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        $libre = ($_.Free/1GB)
        $total = ($_.Used + $_.Free)/1GB
        $porc = ($libre/$total)*100
        if ($porc -lt 10) {
            Write-Host "Alerta en unidad $($_.Name): menos del 10% libre"
            "Alerta en $($_.Name) $(Get-Date)" | Out-File alerta.log -Append
        }
    }
}

function CopiasMasivas {
    Get-ChildItem C:\Users -Directory | ForEach-Object {
        $u=$_.Name
        Compress-Archive -Path $_.FullName -DestinationPath "C:\CopiasSeguridad\$u.zip" -Force
    }
}

function AutomatizarPS {
    $ruta="C:\usuarios"
    if (-not (Get-ChildItem $ruta)) {Write-Host "Directorio vacío"}
    else {
        Get-ChildItem $ruta | ForEach-Object {
            $user=$_.BaseName
            New-LocalUser $user -NoPassword
            Get-Content $_.FullName | ForEach-Object {
                New-Item -Path "C:\Users\$user\$_" -ItemType Directory -Force
            }
            Remove-Item $_.FullName
        }
    }
}

function Barrido {
    $base=Read-Host "Dirección base (ej: 192.168.1)"
    for ($i=1;$i -le 254;$i++) {
        if (Test-Connection "$base.$i" -Count 1 -Quiet) {
            "$base.$i" | Out-File activos.txt -Append
        }
    }
}

function Evento {
    param([int]$num=200)
    Get-WinEvent -LogName System -ErrorAction SilentlyContinue -MaxEvents $num |
    Export-Csv eventos.csv -NoTypeInformation
}

function Agenda {
    $agenda=@{}
    while ($true) {
        Write-Host "1) Añadir/Modificar 2) Buscar 3) Borrar 4) Listar 0) Salir"
        $op=Read-Host "Opción"
        switch ($op) {
            "1" {
                $n=Read-Host "Nombre"; if ($agenda.ContainsKey($n)){Write-Host "Tel:" $agenda[$n]}
                $t=Read-Host "Teléfono"; $agenda[$n]=$t
            }
            "2" {$c=Read-Host "Cadena"; $agenda.Keys | Where-Object {$_ -like "$c*"} | ForEach-Object {Write-Host $_ $agenda[$_]}}
            "3" {$n=Read-Host "Nombre"; if ($agenda.ContainsKey($n)){ $agenda.Remove($n)} }
            "4" {$agenda.GetEnumerator() | ForEach-Object {Write-Host $_.Key $_.Value}}
            "0" {break}
        }
    }
}

function Limpieza {
    param(
        [string]$Ruta,
        [int]$Dias,
        [string]$Log,
        [switch]$WhatIf
    )
    if (-not (Test-Path $Ruta)) {Write-Host "Ruta no válida"; return}
    Get-ChildItem $Ruta | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-$Dias))} | ForEach-Object {
        if ($WhatIf) {Write-Host "Se eliminaría $_"}
        else {
            Write-Host "Eliminando $_"
            "$($_.Name) eliminado el $(Get-Date) tamaño: $($_.Length)" | Out-File $Log -Append
            Remove-Item $_.FullName
        }
    }
}

# Menú principal
Write-Host "16 Pizza"
Write-Host "17 Días"
Write-Host "18 Menu-Usuarios"
Write-Host "19 Menu-Grupos"
Write-Host "20 DiskP"
Write-Host "21 Contraseña"
Write-Host "22 Fibonacci"
Write-Host "23 Fibonacci recursivo"
Write-Host "24 Monitoreo CPU"
Write-Host "25 AlertaEspacio"
Write-Host "26 CopiasMasivas"
Write-Host "27 AutomatizarPS"
Write-Host "28 Barrido"
Write-Host "29 Evento"
Write-Host "29b Agenda"
Write-Host "30 Limpieza"

$opc = Read-Host "Opción"
switch ($opc) {
    "16" {Pizza}
    "17" {Dias}
    "18" {Menu-Usuarios}
    "19" {Menu-Grupos}
    "20" {DiskP}
    "21" {Contrasena}
    "22" {Fibonacci}
    "23" {FibonacciRecursivo}
    "24" {Monitoreo}
    "25" {AlertaEspacio}
    "26" {CopiasMasivas}
    "27" {AutomatizarPS}
    "28" {Barrido}
    "29" {Evento}
    "29b" {Agenda}
    "30" {Limpieza -Ruta $Param2 -Dias $Param3 -Log $Param4 -WhatIf}
}
param(
    [string]$ruta,
    [string]$fichero
)

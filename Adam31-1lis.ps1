# Adamp31-1lis.ps1
# Menú simple: 1 = eventos sistema, 2 = errores sistema último mes, 3 = warnings aplicaciones esta semana

$choice = Read-Host "Elige: 
1) Eventos Sistema  
2) Errores Sistema (último mes)  
3) Warnings Aplicación (esta semana). 
Pulsa otra tecla para salir"

switch ($choice) {
    '1' {
        "Mostrando últimos 50 eventos del registro System..."
        Get-WinEvent -LogName System -MaxEvents 50 |
            Select-Object TimeCreated, Id, ProviderName, LevelDisplayName, @{Name='Msg';Expression={($_.Message -split "`r?`n")[0]}} |
            Format-Table -AutoSize
    }
    '2' {
        $since = (Get-Date).AddMonths(-1)
        "Mostrando errores del registro System desde $($since.ToString('yyyy-MM-dd'))..."
        Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=$since} -ErrorAction SilentlyContinue |
            Select-Object TimeCreated, Id, ProviderName, @{Name='Msg';Expression={($_.Message -split "`r?`n")[0]}} |
            Format-Table -AutoSize
    }
    '3' {
        $since = (Get-Date).AddDays(-7)
        "Mostrando warnings del registro Application desde $($since.ToString('yyyy-MM-dd'))..."
        Get-WinEvent -FilterHashtable @{LogName='Application'; Level=3; StartTime=$since} -ErrorAction SilentlyContinue |
            Select-Object TimeCreated, Id, ProviderName, @{Name='Msg';Expression={($_.Message -split "`r?`n")[0]}} |
            Format-Table -AutoSize
    }
    default {
        Write-Host "Opción no válida o salir. Fin."
    }
}

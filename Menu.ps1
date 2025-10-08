# MENÚ PRINCIPAL
if ($Comando) {
    switch ($Comando) {
        "1" {  }
        "2" {  }
        "3" {  }
        "4" {  }
        "5" {  }
        "6" {  }
        "7" {  }
        "8" {  }
    }
} else {
    do {
        Clear-Host
        Write-Host ""
        Write-Host ""
        Write-Host "" 
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host "0 - Salir"
        
        $SeleccionMenu = Read-Host "Elige una opcion de la lista"
        
        switch ($SeleccionMenu) {
            "1" {  }
            "2" {  }
            "3" {  }
            "4" {  }
            "5" {  }
            "6" {  }
            "7" {  }
            "8" {  }
        }
        if ($SeleccionMenu -ne "0") { Read-Host "Preciona Enter para continuar" }
    } while ($SeleccionMenu -ne "0")

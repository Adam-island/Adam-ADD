param(
    [string]$ruta,
    [string]$fichero
)

Import-Module ActiveDirectory

$entrada = Import-Csv "$ruta\$fichero"
$resultado = @()
$errores = @()

foreach ($linea in $entrada) {
    $usuario = Get-ADUser -Filter "SamAccountName -eq '$($linea.usuario)'" -ErrorAction SilentlyContinue
    if ($null -eq $usuario) {
        $errores += [PSCustomObject]@{
            Fecha=(Get-Date)
            Usuario=$linea.usuario
            Departamento=$linea.departamento
            Error="No existe"
        }
    } else {
        Set-ADUser -Identity $usuario -Department $linea.departamento
        $resultado += $linea
    }
}

if ($resultado) { $resultado | Export-Csv "$ruta\Resultado.csv" -NoTypeInformation }
if ($errores) { $errores | Export-Csv "$ruta\Errores.csv" -NoTypeInformation }

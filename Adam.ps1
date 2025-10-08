function Menu{
    Write-Host "===== Menu Eleccion Script ====="
    Write-Host "16. Pizza"
    Write-Host "17. Dias"
    Write-Host "18. Menu usuarios"
    Write-Host "19. Menu Grupos"
    Write-Host "20. Diskp"
    Write-Host "21. Contraseña"
    Write-Host "22. Fibonacci"
    Write-Host "23. Fibonacci Recursiva"
    Write-Host "24. Monitoreo"
    Write-Host "25. Alerta Espacio"
    Write-Host "==== ==== ==== ==== ==== ==== ===="
    }

function pizza {
   $vegetariana = "Pimiento", "Tofu" 
   $carnivora = "Peperoni", "Jamon", "Salmon"
   $respuesta = Read-Host "Quieres una pizza Vegetariana?"

   if ($respuesta -eq 'Si'){
    
    Write-Host "Ingredientes a elegir (Solo 1 Ingrediente):"
    Write-Host " "

    $vegetariana

    Write-Host " "
    $eleccion = Read-Host "Que ingrediente quiere? (Tomate y Mozarrella Incluidos)"
    

        if (($eleccion -eq "Pimiento") -Or ($eleccion -eq "Tofu")){

            Write-Host " "
            Write-Host "La pizza es vegetariana, y los ingredientes son : Tomate, Mozarrella, $eleccion"
            Write-Host " "
        }
    }
    elseif ($respuesta -eq "No"){
        
    Write-Host "Ingredientes a elegir (Solo 1 Ingrediente):"
    Write-Host " "

    $carnivora

    Write-Host " "
    $eleccion = Read-Host "Que ingrediente quiere? (Tomate y Mozarrella Incluidos)"

    if (($eleccion -eq "Peperoni") -Or ($eleccion -eq "Jamon") -Or ($eleccion -eq "Salmon")){

            Write-Host " "
            Write-Host "La pizza no es vegetariana, y los ingredientes son : Tomate, Mozarrella, $eleccion"
            Write-Host " "
        }
    }
   


}


function dias{


Write-Host "Calcular el número de días pares e impares que hay en un año bisiesto: "
$meses = 31,29,31,30,31,30,31,31,30,31,30,31
$pares = 0
$impares = 0
foreach ($diasMes in $meses) {
    for ($dia = 1; $dia -le $diasMes; $dia++) {
        if ($dia % 2 -eq 0) { 
             $pares++ 
        }else{ 
             $impares++ 
         }
    }
}

    Write-Host "Dias Pares:$pares || Dias Impares:$impares"
    
}

function menu_usuarios{

do{
    Write-Host "============================"
    Write-Host "1. Listar Usuarios"
    Write-Host "2. Crear Usuarios"
    Write-Host "3. Eliminar usuario"
    Write-Host "4. Modificar"
    Write-Host "5. Salir"
    Write-Host "============================"
    
    $opcion = Read-Host "Elige"

    if($opcion -eq "1"){
        
        $listar = Get-LocalUser -Name "*"

        Write-Host $listar
    }elseif($opcion -eq "2"){

        $nombre = Read-Host "Nombre de Usuario Nuevo"
        $contrasenia = Read-Host "Escriba la Contraseña del usuario" -AsSecureString -Force
        
        New-LocalUser -Name $nombre -Password $contrasenia

        Write-Host "Usuario Creado"
    }elseif($opcion -eq "3"){

        $del = Read-Host "Que usuario quieres eliminar?"

        Remove-LocalUser -Name $del

        Write-Host "Usuario $del Eliminado"
    }elseif($opcion -eq "4"){

        $nombre_existente = Read-Host "Introduzca el nombre del Usuario a Modificar"
        $nombre_nuevo = Read-Host "Introduzca el nuevo nombre del Usuario"

        Rename-LocalUser -Name $nombre_existente -NewName $nombre_nuevo

    }
}

while ($opcion -ne 5)

}

function menu_grupos{

    do{
    Write-Host "============================"
    Write-Host "1. Listar Grupos"
    Write-Host "2. Crear Grupos"
    Write-Host "3. Eliminar Grupos"
    Write-Host "4. Crear Miembro de un Grupo"
    Write-Host "5. Eliminar Miembro de un Grupo"
    Write-Host "6. Salir"
    Write-Host "============================"

    $opcion = Read-Host "Elige una opcion"

    if($opcion -eq "1"){

        Get-ADGroup -Filter * | ForEach-Object {
        Write-Host "Grupo: $($_.Name)"
        Get-ADGroupMember -Identity $_.Name | ForEach-Object {
        Write-Host " $($_.Name)"
        }
        }
    }elseif($opcion -eq "2"){
     
        $crear = Read-Host "Dime el nombre del Nuevo Grupo"
        New-ADGroup -Name $crear -GroupScope Global
    }elseif($opcion -eq "3"){

        $del = Read-Host "Dime el grupo que quieres eliminar"
        Remove-ADGroup -Identity $del

    }elseif($opcion -eq "4"){
        

        $nuevousu = Read-Host "Usuario a meter en el grupo"
        $grupo = Read-Host "Grupo en el que metemos el usuario"
        $listausuario = Get-LocalUser -Name "$nuevousu" -ErrorAction SilentlyContinue
        if ($listausuario){
            Add-ADGroupMember -Identity $grupo -Members $nuevousu
        }else{

            New-ADUser -Name $nuevousu 
            Add-ADGroupMember -Identity $grupo -Members $nuevousu
        }

        Write-Host "AGREGADO CORRECTAMENTE" -ForegroundColor Green
    }elseif ($opcion -eq "5"){

        $usuario = Read-Host "Que usuario quieres eliminar"
        $grupo = Read-Host "De que Grupo"

        Remove-ADGroupMember -Identity $grupo -Members $usuario

    }
        
    }

    while($opcion -ne 6)

}


function diskp{

  $ndisco = Read-Host "Que disco quieres utilizar?"
  $tamaño = (Get-Disk -Number $ndisco| Select-Object Size).Size /1GB 
  Write-Host "El disco $ndisco tiene un espacio de $tamaño GB."

  @"
  sel disk $ndisco
  clean
  conv gpt
  con dyn
"@ | diskpart

  $volumen = 0
  for ($disco = 1;$disco -le $tamaño;$disco++){
    $volumen++

    @"
    sel disk $ndisco
    create volume simple size = 1024
    format fs='NTFS' label='Volumen $volumen' 'quick'

"@ | diskpart
  }
     
}

function contraseña{

    $intento = Read-Host "Escriba una contraseña y le diremos si es valida"

    if($intento -notmatch "[qwertyuiopñlkjhgf]"){
    Write-Host "Vaya mierda de contraseña" -ForeGroundColor Red
    break
    }

    if($intento -notmatch "[QWERTYUIOPÑLKJHGF]"){
    Write-Host "Vaya mierda de contraseña" -ForeGroundColor Red
    break
    }

    if($intento -notmatch "[123456]"){
    Write-Host "Vaya mierda de contraseña" -ForeGroundColor Red
    break
    }

    if($intento -notmatch "[,._-]"){
    Write-Host "Vaya mierda de contraseña" -ForeGroundColor Red
    break
    }

    if($intento.Length -ge 8){
    Write-Host "Creeeeema" -ForeGroundColor Green
    break
    }

    Write-Host "Vaya chusta de contraseña" -ForeGroundColor Red


}

function Fibonacci{

    $resul = Read-Host "Elige cuantas veces hacer el fibonacci"
    $intentos = 0

    $num1 = 0
    $num2 = 1
    $combi = 0,1

    while($intentos -lt ($resul - 2)){

        if($num1 -le $num2){
            $suma1 = $num1 + $num2
            $num1 = $suma1
            $combi += $num1
        }else{

            $suma2 = $num1 + $num2
            $num2 = $suma2
            $combi += $num2

        }

        $intentos++
    
}

    if($resul -eq 1){
        $combi = 0

    }elseif($resul -eq 0){
        $combi = "Metete un dedito en el culo"

    }
    Write-Host $combi

}   

function Fibonacci_recursiva(){

    function Fibonacci2($num){
        
        if ($num -lt 2){
    
            return $num

        }else{

            return (Fibonacci2 ($num - 1)) + (Fibonacci2 ($num - 2))

        }
    }

    $sel = Read-Host "Cuantas veces se va a repetir?"

    for($i= 0;$i -lt $sel;$i++){
        Write-Host "$(Fibonacci2 $i)"
    }


} 

function monitoreo{

    $i = 0
    $numeros = 0

    while ($i -lt 6) {
        $uso = (Get-CimInstance Win32_Processor).LoadPercentage
        Start-Sleep -Seconds 5

        Write-Host "Uso de la CPU: ",$uso

        $numeros = $numeros + $uso


        $i++
    }


$media = $numeros / 6
Write-Host "la media es: $media"
}

function AlertaEspacio{

}

do{
    Menu
    $seleccion = Read-Host "Elije una opcion del 16-30 (0 Para Salir)"

    switch($seleccion){
        "16"{Pizza}
        "17"{dias}
        "18"{menu_usuarios}
        "19"{menu_grupos}
        "20"{diskp}
        "21"{contraseña}
        "22"{Fibonacci}
        "23"{Fibonacci_recursiva}
        "24"{monitoreo}
        "25"{AlertaEspacio}
    }
}
while ($seleccion -ne "0")


<?php
$a = session_id();
if(empty($a)) session_start();
$a = session_id();
//echo "<br />session_id(): " . $a
?>

<?php
	//Crear la conexión
	$srv="sqlserver";
	$opc=array("Database"=>"wordleAndresX2", "UID"=>"sa", "PWD"=>"12345Ab##");
	$con=sqlsrv_connect($srv,$opc) or die(print_r(sqlsrv_errors(), true));
	$sql="select
	substring(PALABRA_INTENTADA,1,1) as pal1,
	substring(PALABRA_INTENTADA,2,1) as pal2,
	substring(PALABRA_INTENTADA,3,1) as pal3,
	substring(PALABRA_INTENTADA,4,1) as pal4,
	substring(PALABRA_INTENTADA,5,1) as pal5,
	substring(CODIF,1,1) as res1,
	substring(CODIF,2,1) as res2,
	substring(CODIF,3,1) as res3,
	substring(CODIF,4,1) as res4,
	substring(CODIF,5,1) as res5,pa.nombre as palabradehoy from intentos i
	 inner join partida p on p.id=i.IDPARTIDA
	inner join jugadores j on p.IDJUGADOR=j.id
	inner join palabras pa on p.IDPALABRA=pa.ID
	where j.NICK = '" . $a . "' and p.fecha = cast(getdate() as date)";
	$res=sqlsrv_query($con,$sql);

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Wordle de Bernat</title>
	<link rel="stylesheet" href="style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body id="body">
<div class="container">
  <div class="abs-center">
    
 

	<h1 >Wordle de AndresX2</h1>
	<div class ="wordle ">
	<?php 

	$contador = 1;
	$palabradehoy="";
	while($row=sqlsrv_fetch_array($res))
	{
		$palabradehoy = $row['palabradehoy'];
			?>
        <div class="linea">
			<div class="cuadrado <?php echo $row['res1'];?>" > <?php echo $row['pal1'];?></div>
			<div class="cuadrado <?php echo $row['res2'];?>" > <?php echo $row['pal2'];?></div>
			<div class="cuadrado <?php echo $row['res3'];?>" > <?php echo $row['pal3'];?></div>
			<div class="cuadrado <?php echo $row['res4'];?>" > <?php echo $row['pal4'];?></div>
			<div class="cuadrado <?php echo $row['res5'];?>" > <?php echo $row['pal5'];?></div>
    	</div>
	<?php
	$contador++;
}
sqlsrv_close($con);
$palabrasintentadas=$contador;
while ($contador <=6)
{
	?>
		<div class="linea">
			<div class="cuadrado" ></div>
			<div class="cuadrado" ></div>
			<div class="cuadrado" ></div>
			<div class="cuadrado" ></div>
			<div class="cuadrado" ></div>
		</div>
	<?php
	$contador++;
}
?>
<?php 
		if($palabrasintentadas >6)
			echo "La palabra de hoy era:" . $palabradehoy;
		?>

		<form  class="border p-3 form" method="post" action="./guardarintento.php">
    	  	<div class="form-group">
        		<input type="text" name="palabra" id="palabra" class="form-control" maxlength="5" autofocus <?php 
		if($palabrasintentadas >6)
			echo "disabled"
		?>>
      		</div>
       	 	<button type="submit" class="btn btn-primary" style="display:none;" >enviar</button>
    	</form>
	

	</div>

  </div>
</div>

</body>
</html>

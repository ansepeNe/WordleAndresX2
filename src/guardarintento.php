<?php
echo $_POST["palabra"];
$a = session_id();
if(empty($a)) session_start();
$a = session_id();

$srv="sqlserver";
$opc=array("Database"=>"wordleAndresX2", "UID"=>"sa", "PWD"=>"12345Ab##");
$con=sqlsrv_connect($srv,$opc) or die(print_r(sqlsrv_errors(), true));
$sql="exec Tr_Jugar '". $a. "','".$_POST["palabra"]."'";
$res=sqlsrv_query($con,$sql);
sqlsrv_close($con);



header('Location: ./');
exit;
?>
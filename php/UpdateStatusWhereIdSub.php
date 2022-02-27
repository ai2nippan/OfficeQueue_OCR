<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

// if (!$link->set_charset("utf8")) {
    //printf("Error loading character set utf8: %s\n", $link->error);
    // exit();
	// }


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$idSub  = $_GET['idSub'];		
		$status = $_GET['status'];
		
		
							
		$sql = "UPDATE `events` SET `status` = '$status' WHERE idSub = '$idSub'";

		//$result = mysqli_query($link, $sql);
		$result = mysql_query($sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Office Queue";
   
}

	//mysqli_close($link);
	mysql_close($link);
?>
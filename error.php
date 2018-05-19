<?php
    if (isset($_SESSION['error'])){
        $err_msg = $_SESSION['error'];
        $js = "alert('$err_msg');";
        echo $js;
        unset($_SESSION['error']);
    }
?>
<?php
if (!isset($_SESSION['expired']) && !isset($_COOKIE['username'])){
    header('Location: index.php');
    exit();
}
else if (time() > $_SESSION['expired']){
    setcookie("username", "", time() - (3*60*60), "/");
    session_unset();
    session_destroy();
    header('Location: index.php');
    exit();
}
?>
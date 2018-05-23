<?php
    session_start();
    unset($_SESSION['username']);
    unset($_SESSION['last_active']);
    unset($_SESSION['expired']);
    session_destroy();
    setcookie("username", "", time() - (3*60*60), "/");
    header('Location: index.php');
    exit();
?>
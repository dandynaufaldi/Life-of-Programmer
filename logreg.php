<?php
    include_once ('_conn.php');
    if (isset($_POST['r_username']) && isset($_POST['r_password']) && isset($_POST['r_name'])){
        $username = mysqli_real_escape_string($db, $_POST['r_username']);
        $pass = mysqli_real_escape_string($db, $_POST['r_password']);
        $name = mysqli_real_escape_string($db, $_POST['r_name']);
        $ql = "CALL sp_register('$username', '$pass', '$name')";
        $result = $db->query($ql);
        $data = $result->fetch_array();
        if ($data[0] != 0){
            $_SESSION['error'] = $data[1];
            header('Location: index.php');
            exit();
        }
        else{
            $_SESSION['username'] = $username;
            $_SESSION['last_active'] = time();
            $_SESSION['expired'] = $_SESSION['last_active'] + (3 * 60 * 60);
            setcookie("username", $username, time() + (3*60*60), "/");
            header('Location: home.php');
            exit();
        }
    }
    else if (isset($_POST['l_username']) && isset($_POST['l_password'])){
        $username = mysqli_real_escape_string($db, $_POST['l_username']);
        $pass = mysqli_real_escape_string($db, $_POST['l_password']);
        $ql = "CALL sp_login('$username', '$pass')";
        $result = $db->query($ql);
        $data = $result->fetch_array();
        if ($data[0] != 0){
            $_SESSION['error'] = $data[1];
            header('Location: index.php');
            exit();
        }
        else{
            $_SESSION['username'] = $username;
            $_SESSION['last_active'] = time();
            $_SESSION['expired'] = $_SESSION['last_active'] + (3 * 60 * 60);
            setcookie("username", $username, time() + (3*60*60), "/");
            header('Location: home.php');
            exit();
        }
    }
    else if (isset($_POST['logout'])){
        unset($_SESSION['username']);
        unset($_SESSION['last_active']);
        unset($_SESSION['expired']);
        session_destroy();
        setcookie("username", "", time() - (3*60*60), "/");
        header('Location: index.php');
        exit();
    }
?>
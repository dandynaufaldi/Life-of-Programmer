<?php
include_once ('_conn.php');
function getLastURL(){
    $str = $_SERVER['REQUEST_URI'];
    return substr($str, strrpos($str, '/') + 1);
}
?>
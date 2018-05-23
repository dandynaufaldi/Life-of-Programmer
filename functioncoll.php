<?php
    include_once ('_conn.php');

    function getLastURL(){
        $str = $_SERVER['REQUEST_URI'];
        return substr($str, strrpos($str, '/') + 1);
    }

    //username -> level, curr healt, curr exp, curr money, level
    //level -> max health , max exp

    function getUserStats($id){
        global $db;
        $q = "SELECT LEVEL_ID, USER_EXP, USER_MONEY, USER_STAMINA FROM user WHERE USER_ID = '$id'";
        $result = $db->query($q);
        $data = $result->fetch_array();
        return $data;
    }

    function getMaxStamina($level){
        global $db;
        $q = "SELECT LEVEL_MAX_STAMINA FROM level_user WHERE LEVEL_ID = '$level'";
        $result = $db->query($q);
        $data = $result->fetch_array();
        return $data['LEVEL_MAX_STAMINA'];
    }

    function getMaxExp($level){
        global $db;
        $q = "SELECT LEVEL_MAX_EXP FROM level_user WHERE LEVEL_ID = '$level'";
        $result = $db->query($q);
        $data = $result->fetch_array();
        return $data['LEVEL_MAX_EXP'];
    }

    function getUserID($username){
        global $db;
        $q = "SELECT USER_ID FROM user WHERE USER_UNAME = '$username'";
//        var_dump($q);
        $result = $db->query($q);
//        var_dump($result);
        $data = $result->fetch_array();
        return $data['USER_ID'];
    }

    function getActiveCourse($userid){
        global $db;
        $q = "SELECT * FROM user_course WHERE USER_ID = '$userid'";
        $result = $db->query($q);
        $data = $result->fetch_array();
        return $data;
    }

?>
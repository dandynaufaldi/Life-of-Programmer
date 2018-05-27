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
        $q = "CALL sp_getuserstats('$id')";
        $result = $db->query($q);
        $data = $result->fetch_assoc();
        $result->close();
        $db->next_result();
        return $data;
    }

    function getMaxStamina($level){
        global $db;
        $q = "CALL sp_getmaxstamina('$level')";
        $result = $db->query($q);
        $data = $result->fetch_assoc();
        $result->close();
        $db->next_result();
        return $data['LEVEL_MAX_STAMINA'];
    }

    function getMaxExp($level){
        global $db;
        $q = "CALL sp_getmaxexp('$level')";
        $result = $db->query($q);
        $data = $result->fetch_assoc();
        $result->close();
        $db->next_result();
        return $data['LEVEL_MAX_EXP'];
    }

    function getUserID($username){
        global $db;
        $q = "CALL sp_getuserid('$username')";
        $result = $db->query($q);
        $data = $result->fetch_assoc();
        $result->close();
        $db->next_result();
        return $data['USER_ID'];
    }

    function getQueryRes($q){
        global $db;
        $result = $db->query($q);
        if (!$result)
            return false;
        return $result;
    }

//    function getActiveCourse($userid){
//        $q = "SELECT * FROM user_course WHERE USER_ID = '$userid'";
//        $data = getQueryRes($q);
//        return $data;
//    }
//
//    function getActiveJob($userid){
//        $q = "SELECT j.JOB_NAME, j.JOB_DURATION, uj.USER_JOB_START FROM user_job uj JOIN job j ON ( uj.JOB_ID = j.JOB_ID AND uj.USER_ID = '$userid')";
//        $data = getQueryRes($q);
//        return $data;
//    }

    function getUserSkill($userid){
        $q = "CALL sp_getuserskill('$userid')";
        $data = getQueryRes($q);
        return $data;
    }

    function getUserCourse($userid){
        $q = "CALL sp_getusercourse('$userid')";
        $data = getQueryRes($q);
        return $data;
    }

    function getUserJob($userid){
        $q = "CALL sp_getuserjob('$userid')";
        $data = getQueryRes($q);
        return $data;
    }

    function getUserEquip($userid){
        $q = "CALL sp_getuserequip('$userid')";
        $data = getQueryRes($q);
        return $data;
    }

    function getLeaderBoard(){
        $q = "CALL sp_leaderboard()";
        $data = getQueryRes($q);
        return $data;
    }

    function getListCourse(){
        $q = "CALL sp_listcourse()";
        $data = getQueryRes($q);
        return $data;
    }

    //nanti cek lv kalau null -> beli, ga null -> upgrade
    function getListEquip($userid){
        $q = "CALL sp_listequip('$userid')";
//        echo $q.'<br>';
        $data = getQueryRes($q);
        return $data;
    }

    // jangan lupa split nama equip dan lv equip
    function getListJob(){
        $q = "CALL sp_listjob()";
        $data = getQueryRes($q);
        return $data;
    }
?>
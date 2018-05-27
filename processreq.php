<?php
    include_once ('_conn.php');
    include_once ('functioncoll.php');
    $userid = getUserID($_SESSION['username']);
//    var_dump($_SESSION);
    if (isset($_GET['courseid'])){
        $id_course = $_GET['courseid'];
        $nama_course = $_GET['coursenama'];
        $durasi_course = $_GET['coursedurasi'];
        $q = "CALL sp_takecourse('$userid', '$id_course')";
        $data = getQueryRes($q);
//        var_dump($data);
        if ($data){
            $result = $data->fetch_array();
            echo"<br>";
            var_dump($result);
            if ($result[0] != 0){
                $_SESSION['error'] = $result[1];
            }
            else{
                $_SESSION['active'] = true;
                $_SESSION['jenis'] = 'course';
                $_SESSION['id'] = $id_course;
                $_SESSION['nama'] = $nama_course;
                $_SESSION['duration'] = $durasi_course;
            }
            $data->close();
        }
        $db->next_result();
        header('Location: course.php');
        exit();

    }

    else if (isset($_POST['c_id_course']) && isset($_POST['c_id_user'])){
        $courseid = $_SESSION['id'];
        $q = "CALL sp_takecoursereward('$userid', '$courseid')";
        $data = getQueryRes($q);
//        var_dump($data);
        if ($data){
            $result = $data->fetch_array();
            if ($result[0] != 0){
                $_SESSION['error'] = $result[1];
            }
            echo $result[0];
            $data->close();
        }
        $db->next_result();
        unset($_SESSION['active']);
        unset($_SESSION['jenis']);
        unset($_SESSION['id']);
        unset($_SESSION['nama']);
        unset($_SESSION['duration']);
//        header('Location: course.php');
        exit();
    }

    else if (isset($_GET['jobid'])){
        $id_job = $_GET['jobid'];
        $nama_job = $_GET['jobnama'];
        $durasi_job = $_GET['jobdurasi'];
        $q = "CALL sp_takejob('$userid', '$id_job')";
        $data = getQueryRes($q);
        var_dump($data);
        if ($data){
            $result = $data->fetch_array();
            echo"<br>";
            var_dump($result);
            if ($result[0] != 0){
                $_SESSION['error'] = $result[1];
            }
            else{
                $_SESSION['active'] = true;
                $_SESSION['jenis'] = 'job';
                $_SESSION['id'] = $id_job;
                $_SESSION['nama'] = $nama_job;
                $_SESSION['duration'] = $durasi_job;
            }
            $data->close();
        }
        $db->next_result();
        header('Location: job.php');
        exit();
    }

    else if (isset($_POST['c_id_job']) && isset($_POST['c_id_user'])){
        $jobid = $_SESSION['id'];
        $q = "CALL sp_takejobreward('$userid', '$jobid')";
        $data = getQueryRes($q);
        if ($data){
            $result = $data->fetch_array();
            if ($result[0] != 0){
                $_SESSION['error'] = $result[1];
            }
            echo $result[0];
            $data->close();
        }
        $db->next_result();
        unset($_SESSION['active']);
        unset($_SESSION['jenis']);
        unset($_SESSION['id']);
        unset($_SESSION['nama']);
        unset($_SESSION['duration']);
        exit();
    }
    else if (isset($_GET['equipid'])){
        $id_eq = $_GET['equipid'];
        $q = "CALL sp_upgrade('$userid', '$id_eq')";
        $data = getQueryRes($q);
        var_dump($data);
        if ($data){
            $result = $data->fetch_array();
            echo"<br>";
            var_dump($result);
            if ($result[0] != 0){
                $_SESSION['error'] = $result[1];
            }
            $data->close();
        }
        $db->next_result();
        header('Location: equipment.php');
        exit();
    }
?>
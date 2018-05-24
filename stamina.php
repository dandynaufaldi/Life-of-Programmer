<?php
    include_once ('_conn.php');
    if (isset($_POST['stamina_id'])){
        $idstamina = $_POST['stamina_id'];
        $q = "CALL sp_updatestamina('$idstamina')";
        $result = $db->query($q);
        $res = 'hehe';
        if ($result || $result->num_rows > 0){
            $data = $result->fetch_array();
            $result->close();
            $res = $data[0];
        }
        echo $res;
        $db->next_result();
    }

?>
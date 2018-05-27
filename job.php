<?php
include_once ('_conn.php');
include_once ('cekuser.php');
?>
<html>
<?php include_once ('layout/head.php');?>
<body>
<?php include_once ('layout/navbar.php');?>

<?php $jobs = getListJob();
function array_push_assoc($array, $key, $value){
    $array[$key] = $value;
    return $array;
//    var_dump($_SESSION);
}
?>
<h3 style="text-align: center;">List of Job</h3>
<div class="container">
    <div class="col-md-8 col-md-offset-2">
        <table id="course" class="table table-bordered table-hover">
            <thead class="text-center">
            <tr>
                <td>#</td>
                <td>Name</td>
                <td>Req. Skill</td>
                <td>Req. Equipment (Lvl)</td>
                <td>Duration</td>
                <td>Exp (+)</td>
                <td>Stamina (-)</td>
                <td>Money $ (+)</td>
                <td>Action</td>
            </tr>
            </thead>
            <tbody>
            <?php
            if ($jobs){
                $no = 1;
                while ($job = $jobs->fetch_assoc()){
                    $j_id = $job['JOB_ID'];
                    $j_nama = $job['JOB_NAME'];
                    $j_duration = $job['JOB_DURATION'];
                    $j_exp = $job['JOB_EXPERIENCE'];
                    $j_stamina = $job['JOB_STAMINA'];
                    $j_money = $job['JOB_PAYMENT'];
                    $j_reqskill = $job['REQ_SKILL'];
                    $list_eq_name = explode(',', $job['REQ_EQ_NAME']);
                    $list_eq_lv = explode(',', $job['REQ_EQ_LV']);
                    $temp_eq = array();
                    $arrsize = count($list_eq_name);
                    for ($i = 0; $i < $arrsize ; $i++){
                        $temp_eq = array_push_assoc($temp_eq, $list_eq_name[$i], $list_eq_lv[$i]);
                    }
                    $j_req_eq = array();
                    foreach($temp_eq as $x => $x_value) {
                        $bb = $x.' ('.$x_value.')';
                        array_push($j_req_eq, $bb);
                    }
                    $j_req_eq = implode(", ", $j_req_eq);
                    $j_action = "<a href=\"processreq.php?jobid=$j_id&jobnama=$j_nama&jobdurasi=$j_duration\" class=\"btn btn-warning\" role=\"button\">Take</a>";
                    echo '<tr>';
                    echo "<td>$no</td>";
                    echo "<td>$j_nama</td>";
                    echo "<td>$j_reqskill</td>";
                    echo "<td>";
                    echo ($j_req_eq) ;
                    echo "</td>";
                    echo "<td>$j_duration</td>";
                    echo "<td>$j_exp</td>";
                    echo "<td>$j_stamina</td>";
                    echo "<td>$j_money</td>";
                    echo "<td>$j_action</td>";
                    echo '</tr>';
                    $no += 1;
                }
                $jobs->close();
            }
            $db->next_result();
            ?>
            </tbody>
        </table>
    </div>
</div>


</body>
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/datatables.min.js"></script>
<script>
    $(document).ready( function () {
        $('#course').DataTable();
    } );
    <?php
    include_once ('error.php');
    ?>
</script>
<?php
include_once ('layout/script.php')
?>
</html>
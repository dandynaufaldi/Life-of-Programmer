<?php
include_once ('_conn.php');
include_once ('cekuser.php');
?>
<html>
<?php include_once ('layout/head.php');?>
<body>
<?php include_once ('layout/navbar.php');?>

<?php $equips = getListEquip($userid);?>
<h3 style="text-align: center;">List of Equipment</h3>
<div class="container">
    <div class="col-md-8 col-md-offset-2">
        <table id="course" class="table table-bordered table-hover">
            <thead class="text-center">
            <tr>
                <td>#</td>
                <td>Name</td>
                <td>Owned Level</td>
                <td>Cost $ (-)</td>
                <td>Action</td>
            </tr>
            </thead>
            <tbody>
            <?php
            if ($equips){
                $no = 1;
                while ($equip = $equips->fetch_assoc()){
//                    var_dump($equip);
                    $e_id = $equip['UPGRADE_ID'];
                    $e_nama = $equip['UPGRADE_NAME'];
                    $e_level = ($equip['USER_EQUIPMENT_LEVEL'] != NULL)?$equip['USER_EQUIPMENT_LEVEL']:'-';
                    $base_cost = (int)$equip['UPGRADE_COST'];
                    $up_cost = (int)$equip['UPGRADE_LEVELCOST'];
                    $e_money = ($e_level == '-')?$base_cost:$base_cost+$up_cost*(int)$e_level;
                    $act = ($e_level == '-')?'Buy':'Upgrade';
                    $e_action = "<a href=\"processreq.php?equipid=$e_id\" class=\"btn btn-warning\" role=\"button\">$act</a>";
                    echo '<tr>';
                    echo "<td>$no</td>";
                    echo "<td>$e_nama</td>";
                    echo "<td>$e_level</td>";
                    echo "<td>$e_money</td>";
                    echo "<td>$e_action</td>";
                    echo '</tr>';
                    $no += 1;
                }
                $equips->close();
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
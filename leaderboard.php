<?php
include_once ('_conn.php');
?>
<html>
<?php include_once ('layout/head.php');?>
<body>
<?php include_once ('layout/navbar.php');?>

<?php $leaders = getLeaderBoard();?>
<h3 style="text-align: center;">Leaderboard</h3>
<div class="container">
    <div class="col-md-4 col-md-offset-4">
        <table id="leaderboard" class="table table-bordered table-hover text-center">
            <thead>
            <tr>
                <td>#</td>
                <td>Username</td>
                <td>Level</td>
            </tr>
            </thead>
            <tbody>
            <?php
            if ($leaders){
                $no = 1;
                while ($leader = $leaders->fetch_array()){
                    echo '<tr>';
                    echo '<td>'.$no.'</td>';
                    echo '<td>'.$leader[0].'</td>';
                    echo '<td>'.$leader[1].'</td>';
                    echo '</tr>';
                    $no += 1;
                }
                $leaders->close();
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
        $('#leaderboard').DataTable({
            "order": [[ 2, "desc" ]]
        });
    } );
</script>
<?php
include_once ('error.php');
include_once ('layout/script.php')
?>
</html>
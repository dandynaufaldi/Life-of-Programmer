<?php
include_once ('_conn.php');
?>
<html>
    <?php include_once ('layout/head.php');?>
    <body>
        <?php include_once ('layout/navbar.php');?>

        <?php $skills = getUserSkill($userid);?>
        <h3 style="text-align: center;">My Skill</h3>
        <div class="container">
            <div class="col-md-4 col-md-offset-4">
                <table id="skilltable" class="table table-bordered table-hover text-center">
                    <thead>
                        <tr>
                            <td>#</td>
                            <td>Skill Name</td>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        if ($skills){
                            $no = 1;
                            while ($skill = $skills->fetch_array()){
                                echo '<tr>';
                                echo '<td>'.$no.'</td>';
                                echo '<td>'.$skill[0].'</td>';
                                echo '</tr>';
                                $no +=1;
                            }
                            $skills->close();
                        }
                        $db->next_result();
                        ?>
                    </tbody>
                </table>
            </div>
        </div>

        <?php $equips = getUserEquip($userid); echo $db->error;?>
        <h3 style="text-align: center;">My Equipment</h3>
        <div class="container">
            <div class="col-md-4 col-md-offset-4">
                <table id="equiptable" class="table table-bordered table-hover text-center">
                    <thead>
                    <tr>
                        <td>#</td>
                        <td>Equipment Name</td>
                        <td>Equipment Level</td>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    if ($equips){
                        $no = 1;
                        while ($equip = $equips->fetch_array()){
                            echo '<tr>';
                            echo '<td>'.$no.'</td>';
                            echo '<td>'.$equip[0].'</td>';
                            echo '<td>'.$equip[1].'</td>';
                            echo '</tr>';
                            $no +=1;
                        }
                        $equips->close();
                    }
                    $db->next_result();
                    ?>
                    </tbody>
                </table>
            </div>
        </div>

        <?php $jobs = getUserJob($userid); echo $db->error;?>
        <h3 style="text-align: center;">Job History</h3>
        <div class="container">
            <div class="col-md-4 col-md-offset-4">
                <table id="jobtable" class="table table-bordered table-hover text-center">
                    <thead>
                    <tr>
                        <td>#</td>
                        <td>Time</td>
                        <td>Job Name</td>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    if ($jobs){
                        $no = 1;
                        while ($job = $jobs->fetch_array()){
                            echo '<tr>';
                            echo '<td>'.$no.'</td>';
                            echo '<td>'.$job[0].'</td>';
                            echo '<td>'.$job[1].'</td>';
                            echo '</tr>';
                            $no +=1;
                        }
                        $jobs->close();
                    }
                    $db->next_result();
                    ?>
                    </tbody>
                </table>
            </div>
        </div>

        <?php $courses = getUserCourse($userid); echo $db->error;?>
        <h3 style="text-align: center;">Course History</h3>
        <div class="container">
            <div class="col-md-4 col-md-offset-4">
                <table id="coursetable" class="table table-bordered table-hover text-center">
                    <thead>
                    <tr>
                        <td>#</td>
                        <td>Time</td>
                        <td>Course Name</td>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    if ($courses){
                        $no = 1;
                        while ($course = $courses->fetch_array()){
                            echo '<tr>';
                            echo '<td>'.$no.'</td>';
                            echo '<td>'.$course[0].'</td>';
                            echo '<td>'.$course[1].'</td>';
                            echo '</tr>';
                            $no +=1;
                        }
                        $courses->close();
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
            $('#skilltable').DataTable();
            $('#equiptable').DataTable();
            $('#jobtable').DataTable();
            $('#coursetable').DataTable();
        } );
    </script>
    <?php include_once ('layout/script.php')?>
</html>
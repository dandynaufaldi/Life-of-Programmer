<?php
include_once ('_conn.php');
include_once ('cekuser.php');
?>
<html>
<?php include_once ('layout/head.php');?>
<body>
<?php include_once ('layout/navbar.php');?>

<?php $courses = getListCourse(); ?>
<h3 style="text-align: center;">List of Course</h3>
<div class="container">
    <div class="col-md-8 col-md-offset-2">
        <table id="course" class="table table-bordered table-hover">
            <thead class="text-center">
            <tr>
                <td>#</td>
                <td>Name</td>
                <td>Skill</td>
<!--                <td>Desc</td>-->
                <td>Exp (+)</td>
                <td>Duration (sec)</td>
                <td>Stamina (-)</td>
                <td>Money $ (-)</td>
                <td>Action</td>
            </tr>
            </thead>
            <tbody>
            <?php
            if ($courses){
                $no = 1;
                while ($course = $courses->fetch_assoc()){
                    $c_id = $course['COURSE_ID'];
                    $c_nama = $course['COURSE_NAME'];
                    $c_skill = $course['SKILL_NAME'];
                    $c_desc = $course['COURSE_DESCRIPTION'];
                    $c_exp = $course['COURSE_EXPERIENCE'];
                    $c_duration = $course['COURSE_DURATION'];
                    $c_stamina = $course['COURSE_STAMINA'];
                    $c_money = $course['COURSE_COST'];
                    $c_action = "<a href=\"processreq.php?courseid=$c_id&coursenama=$c_nama&coursedurasi=$c_duration\" class=\"btn btn-warning\" role=\"button\">Take</a>";
                    echo '<tr>';
                    echo "<td>$no</td>";
                    echo "<td>$c_nama</td>";
                    echo "<td>$c_skill</td>";
//                    echo "<td>$c_desc</td>";
                    echo "<td>$c_exp</td>";
                    echo "<td>$c_duration</td>";
                    echo "<td>$c_stamina</td>";
                    echo "<td>$c_money</td>";
                    echo "<td>$c_action</td>";
                    echo '</tr>';
                    $no += 1;
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
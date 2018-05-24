<?php
    include_once ('functioncoll.php');
    $userid = getUserID($_SESSION['username']);
    $user = getUserStats($userid);
    $level = $user['LEVEL_ID'];
    $exp = $user['USER_EXP'];
    $money = $user['USER_MONEY'];
    $stamina = $user['USER_STAMINA'];
    $max_stamina = getMaxStamina($level);
    $max_exp = getMaxExp($level);
    $stamina_width = $stamina/$max_stamina*100;
    $exp_width = $exp/$max_exp*100;
    var_dump($_REQUEST);
?>
<nav class="nav navbar-inverse" style="font-weight: bold;">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="home.php">
                <img alt="Brand" src="img/logo_1.png" style="height: 100%;">
            </a>
        </div>
        <ul class="nav navbar-nav">
            <li class="<?php echo (getLastURL() == 'home.php') ? 'active' : '';?>"><a href="course.php">Home</a></li>
            <li class="<?php echo (getLastURL() == 'course.php') ? 'active' : '';?>"><a href="course.php">Course</a></li>
            <li class="<?php echo (getLastURL() == 'job.php') ? 'active' : '';?>"><a href="job.php">Job</a></li>
            <li class="<?php echo (getLastURL() == 'equipment.php') ? 'active' : '';?>"><a href="equipment.php">Equipment</a></li>
            <li class="<?php echo (getLastURL() == 'leaderboard.php') ? 'active' : '';?>"><a href="leaderboard.php">Leaderboard</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li class="dropdown">
                <a href="" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                    Hi, <?php echo (isset($_SESSION['username']))? $_SESSION['username'] : "";?>
                    <span class="caret"></span>
                </a>
                <ul class="dropdown-menu">
                    <li><a href="logout.php">Logout</a></li>
                </ul>
            </li>
        </ul>
    </div>
</nav>
<nav class="nav navbar-inverse" style="color: #9d9d9d; line-height: 20px; padding: 10px 0px;">
    <div class="container-fluid ">
        <div class="col-md-5 nav navbar-nav" style="padding: 10px 0px;">
            <div class="col-md-4">Now doing:
                <span id="#nowdoing"></span>
            </div>
            <div class="col-md-8" style="font-weight: bold;"></div>
        </div>
        <div class="col-md-7 nav navbar-nav" style="text-align: center;">
            <div class="col-md-3"><span style="font-weight: bold;">Money</span>
                <div id="u_money" style="margin: 5px 0;">$<?php echo $money; ?></div>
            </div>
            <div class="col-md-3"><span style="font-weight: bold;">Stamina</span>
                <div class="progress">
                    <div id="staminabar" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="<?php echo $stamina;?>" aria-valuemin="0" aria-valuemax="<?php echo $max_stamina;?>" style="width: <?php echo $stamina_width;?>%;">
                        <span id="staminaval"><?php echo $stamina.'/'.$max_stamina;?></span>
                    </div>
                </div>
            </div>
            <div class="col-md-4"><span style="font-weight: bold;">Experience</span>
                <div class="progress">
                    <div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="<?php echo $exp;?>" aria-valuemin="0" aria-valuemax="<?php echo $max_exp;?>" style="width: <?php echo $exp_width;?>%;">
                        <span><?php echo $exp;?>/<?php echo $max_exp;?></span>
                    </div>
                </div>
            </div>
            <div class="col-md-2"><span style="font-weight: bold;">Level</span>
                <div id="u_level" style="margin: 5px 0;"><?php echo $level; ?></div>
            </div>
        </div>
    </div>
</nav>
<?php
//    var_dump(getUserStats($userid));
//    echo '<br>';
//    $hehe = getActiveJob($userid);
////    var_dump($hehe);
//    if ($hehe){
//        foreach ($hehe as $hh){
//            echo $hh['JOB_ID'];
//        }
//    }
//
//    echo '<br>';
//    print_r(getMaxExp($level));
//    echo "<br>";
//    $aa = getUserSkill($userid);
//    var_dump($aa->fetch_assoc()) ;
//    $aa->close();
//    $db->next_result();
//    echo "<br>";
////    var_dump(getUserCourse($userid)->fetch_assoc()) ;
//date_default_timezone_set("Asia/Bangkok");
//    echo "<br>"."The time is " . date("H:i:sa");
//?>
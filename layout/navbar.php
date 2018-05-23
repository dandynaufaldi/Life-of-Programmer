<?php include_once ('functioncoll.php');?>
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
        <div class="col-md-6 nav navbar-nav" style="padding: 10px 0px;">
            <div class="col-md-4">Now doing:
                <span id="#nowdoing"></span>
            </div>
            <div class="col-md-8" style="font-weight: bold;"></div>
        </div>
        <div class="col-md-6 nav navbar-nav">
            <div class="col-md-4"><span style="font-weight: bold;">Money</span>
                <div id="u_money">aa</div>
            </div>
            <div class="col-md-3"><span style="font-weight: bold;">Stamina</span>
                <div id="u_stamina">aa</div>
            </div>
            <div class="col-md-3"><span style="font-weight: bold;">Experience</span>
                <div id="u_exp">aa</div>
            </div>
            <div class="col-md-2"><span style="font-weight: bold;">Level</span>
                <div id="u_level">aa</div>
            </div>
        </div>
    </div>
</nav>
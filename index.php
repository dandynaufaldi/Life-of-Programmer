<?php
    include_once ('_conn.php');
?>
<!DOCTYPE html>
<html>
<head>
	<title>Life of Programmer</title>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css?family=Raleway" rel="stylesheet">
    <style>
        body{
            font-family: 'Raleway', sans-serif;
        }
        .btn-default{
            background: none;
            color: white;
            border-color: white;
            border: 2px solid;
        }
    </style>
</head>
<body style="background-image: url('img/landing-back.jpg');">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-2 col-md-offset-10 col-xs-6 col-xs-offset-12" style="margin-top: 20px;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#loginModal">Login</button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#registerModal">Register</button>
            </div>
		</div>
	</div>
    <div id="loginModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Login</h4>
                </div>
                <div class="modal-body">
                    <form action="logreg.php" method="POST">
                        <label for="username_l" class="control-label">Username</label>
                        <div class="input-group">
                            <input id="username_l" type="text" class="form-control" name="username_l" placeholder="Your username" required>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        </div>
                        <br>
                        <label for="l_password" class="control-label">Password</label>
                        <div class="input-group">
                            <input id="l_password" type="password" class="form-control" name="l_password" placeholder="Your password" required>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                        </div>
                        <br>
                        <button type="submit" class="btn btn-primary">Login</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div id="registerModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Register</h4>
                </div>
                <div class="modal-body">
                    <form action="logreg.php" method="POST">
                        <label for="r_username" class="control-label">Username</label>
                        <div class="input-group">
                            <input id="r_username" type="text" class="form-control" name="r_username" placeholder="Your username" required>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        </div>
                        <br>
                        <label for="r_name" class="control-label">Name</label>
                        <div class="input-group">
                            <input id="r_name" type="text" class="form-control" name="r_name" placeholder="Your name" required>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        </div>
                        <br>
                        <label for="r_password" class="control-label">Password</label>
                        <div class="input-group">
                            <input id="r_password" type="password" class="form-control" name="r_password" placeholder="Your password" required>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                        </div>
                        <br>
                        <label for="r_password2" class="control-label">Confirm Password</label>
                        <div class="input-group">
                            <input id="r_password2" type="password" class="form-control" name="r_password2" placeholder="Retype your password" required>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                        </div>
                        <div id="passcheck"></div>
                        <br>
                        <button type="submit" class="btn btn-primary">Register</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-6 col-md-offset-3">
                <h1 style="font-size: 8em; color: white; text-align: center;" class="center-block">
                    <strong>Life<br>of<br>Programmer</strong>
                </h1>
            </div>
        </div>
    </div>
</body>
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>
    <?php
        include_once ('error.php');
    ?>
    $(document).ready(function () {
        $('#r_password2').keyup(function () {
            let pass1 = $('#r_password').val();
            let pass2 = $('#r_password2').val();
            if (pass1 != pass2){
                $('#passcheck').removeClass('text-success');
                $('#passcheck').addClass('text-danger');
                $('#passcheck').text('Password mismatch');
            }
            else{
                $('#passcheck').removeClass('text-danger');
                $('#passcheck').addClass('text-success');
                $('#passcheck').text('Password match');
            }
        });
    });
</script>
</html>
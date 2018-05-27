<?php

?>
<script>

    var updateStamina = function() {
        var userid = <?php echo $userid?>;
        $.ajax({
            url: 'stamina.php',
            data:{
                stamina_id: userid
            },
            // stamina_id: userid,
            type: 'POST',
            success: function(data) {
                console.log('data'+data);
                if (data != ''){
                    console.log('update stamina');
                    $('#staminabar').attr('aria-valuenow', data);
                    let lebar = data*100/<?php echo $max_stamina?>;
                    lebar +='%';
                    console.log('lebar '+lebar);
                    $('#staminabar').css('width', lebar);
                    $('#staminaval').text(data+"<?php echo '/'.$max_stamina?>");
                }
            }
        });
    };
    let stambar = $('#staminabar');
    let valnow = stambar.attr('aria-valuenow');
    let valmax = stambar.attr('aria-valuemax');
    var interval = 1000 * 60 * 1; // where X is your every X minutes
    // if(valnow < valmax)
    setInterval(updateStamina, interval);

    <?php if ( isset($_SESSION['active'])):?>
        if (!localStorage.getItem('expected')){
            let start = new Date().getTime();
            let duration = <?php echo $_SESSION['duration']; ?>;
            duration =Number(duration)*1000;
            let expected = start + duration;
            localStorage.setItem('expected', expected);
            console.log('buat expected '+expected);
        }
        var expected = localStorage.getItem('expected');
        expected = Number(expected);
        var jenis = <?php $j = $_SESSION['jenis']; echo "'".$j."'"; ?>;
        var x = setInterval(function() {
            // Get todays date and time
            var now = new Date().getTime();
            // Find the distance between now an the count down date
            var distance = expected - now;
            // Time calculations for days, hours, minutes and seconds
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);
            // Display the result in the element with id="demo"
            document.getElementById("demo").innerHTML = minutes + "m " + seconds + "s ";
            // If the count down is finished, write some text
            if (distance < 0) {
                console.log('lagi selesai nih');
                clearInterval(x);
                document.getElementById("demo").innerHTML = "FINISH";
                localStorage.clear();
                <?php //if ( isset($_SESSION['jenis']) == 'course'):?>
                if (jenis == 'course') takeCourseRewards();
                else if (jenis == 'job') takeJobRewards();
                <?php //elseif (isset($_SESSION['jenis']) == 'job'):?>

                <?php //endif; ?>
            }
        }, 1000);

        var takeCourseRewards = function () {
            var id_course = <?php echo $_SESSION['id']; ?>;
            var id_user = <?php echo $userid; ?>;
            $.ajax({
                url: 'processreq.php',
                data:{
                    c_id_course: id_course,
                    c_id_user: id_user
                },
                type: 'POST',
                success: function(data) {
                    location.reload();
                }
            });
        };

    var takeJobRewards = function () {
        var id_job = <?php echo $_SESSION['id']; ?>;
        var id_user = <?php echo $userid; ?>;
        $.ajax({
            url: 'processreq.php',
            data:{
                c_id_job: id_job,
                c_id_user: id_user
            },
            type: 'POST',
            success: function(data) {
                location.reload();
            }
        });
    };

    <?php endif; ?>

    // Update the count down every 1 second

</script>


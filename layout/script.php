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
                    $('#staminabar').attr('valuenow', data);
                    let lebar = data*100/<?php echo $max_stamina?>;
                    lebar +='%';
                    console.log('lebar '+lebar);
                    $('#staminabar').css('width', lebar);
                    $('#staminaval').text(data+"<?php echo '/'.$max_stamina?>");
                }
            }
        });
    };

    var interval = 1000 * 60 * 1; // where X is your every X minutes
    setInterval(updateStamina, interval);
</script>


/******************************************
* Author: tcrawford (/u/superp0s)
* Creation Date: 7.17.15
* Description: Creates a simple clock
* that gets updated every second (1000 ms)
******************************************/

function updateClock() {
    // Get the current hours, and minutes
    var now = new Date();
    var hours24 = now.getHours();
    var hours12 = now.getHours();
    var minutes = now.getMinutes();
    
    // If the twelve hour time is greater than 12, subtract 12
    hours12 = (hours12 > 12) ? hours12 - 12 : hours12;
    hours12 = (hours12 === 0) ? 12 : hours12;
    
    // If the number of minutes is '8', then make it '08'
    if (minutes < 10) {
        minutes = '0' + minutes;
    }
    
    // Set by config.js (configuration file for users)
    if (twentyfourhourtime === true) {
        var time = hours24 + ':' + minutes;
    } else {
        var time = hours12 + ":" + minutes;
    }
    
    
    document.getElementById('clock').style.color = timeColor;
    document.getElementById('clock').innerHTML = time;
    
    // Set by config.js (configuration for users)
    if (showBackground === true) {
        // Show background color
        // $('#clock').css({"background-color": "rgba(240, 240, 240, 0.5)"});
        $('#clock').css('background-color', bgColor);
    } else {
        $('#clock').css('background-color', 'rgba(0,0,0,0)');
    }
    
    // 
    $('html').css('top', clockPosFromTop + "px");
}

setInterval(updateClock, 1000);
updateClock();

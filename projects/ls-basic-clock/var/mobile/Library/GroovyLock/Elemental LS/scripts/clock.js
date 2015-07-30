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

    var marginLeft = -1 * (boxWidth / 2);

    $('#clock').html(time);
    $('#clock').css('color', timeColor);
    $('#box').css('width', boxWidth + "px");
    $('#box').css('height', boxHeight + "px");
    $('#clock').css('text-align', textAlign);
    $('#clock').css('font-size', fontSize + "px");
    $('#clock').css('letter-spacing', letterSpacing + "px")

    // Set by config.js (configuration for users)
    if (showBackground === true) {
        // Show background color
        $('#clock').css('background-color', bgColor);
    } else {
        $('#clock').css('background-color', 'rgba(0,0,0,0)');
    }

    if (showShadow === true) {
        $('#box').css('box-shadow', shadow);
    }

    // Due to the way these tags act, the JQuery method was used to put items where
    // they need to be at runtime
    $('html').css('top', clockPosFromTop + "px");
    $('body').css('margin-left', marginLeft + "px")
}

setInterval(updateClock, 1000);
updateClock();

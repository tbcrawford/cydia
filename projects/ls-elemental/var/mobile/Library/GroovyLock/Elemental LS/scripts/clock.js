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
    if (twentyfourhourtime) {
        var time = hours24 + ':' + minutes;
    } else {
        var time = hours12 + ':' + minutes;
    }

    if (zeroUnderTen) {
        if (hours12 < 10) {
            time = '0' + time;
        }
    }

    var marginLeft = -1 * (boxWidth / 2);

    $('#clock').html(time);
    $('#clock').css('color', timeColor);
    $('#box').css('width', boxWidth + "px");
    $('#box').css('height', boxHeight + "px");
    $('#clock').css('text-align', textAlign);
    $('#clock').css('font-size', fontSize);
    $('#clock').css('letter-spacing', letterSpacing);
    $('#clock').css('border-radius', cornerRadius);
    $('#clock').css('border', borderStroke);

    // Set by config.js (configuration for users)
    if (showBox) {
        // Show background color
        $('#clock').css('background-color', boxColor);
    } else {
        $('#clock').css('background-color', 'rgba(0,0,0,0)');
    }

    if (showShadow) {
        $('#clock').css('box-shadow', shadow);
    }

    if (window.groovyAPI) {
        if (groovyAPI.isShowingNotifications()) {
            $('html').animate({ 'top': "0px" }, 1000);
        } else {
            $('html').animate({ 'top': clockPositionFromTop }, 1000);
        }
    }

    // $('html').css('top', clockPositionFromTop);
    $('body').css('margin-left', marginLeft + "px")
}

setInterval(updateClock, 1000);

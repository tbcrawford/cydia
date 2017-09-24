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
    var time = "";

    // If the twelve hour time is greater than 12, subtract 12
    hours12 = (hours12 > 12) ? hours12 - 12 : hours12;
    hours12 = (hours12 === 0) ? 12 : hours12;

    // If the number of minutes is '8', then make it '08'
    if (minutes < 10) {
        minutes = '0' + minutes;
    }

    // Set by config.js (configuration file for users)
    if (twentyfourhourtime) {
        time = hours24 + ':' + minutes;
    } else {
        time = hours12 + ':' + minutes;
    }

    if (zeroUnderTen) {
        if (!twentyFourHourTime) {
            if (hours12 < 10) {
                time = '0' + time;
            }
        }
    }

    $('.clock').html(time);
    $('.clock').css('color', timeColor);
    $('.box').css('width', boxWidth + "px");
    $('.clock').css('text-align', textAlign);
    $('.clock').css('font-size', fontSize);
    $('.clock').css('letter-spacing', letterSpacing);
    $('.clock').css('border-radius', cornerRadius);
    $('.clock').css('border', borderStroke);

    // Show background color
    if (showBox) {
        $('.clock').css('background-color', boxColor);
    }

    if (showShadow) {
        $('.clock').css('box-shadow', shadow);
    }

    if (window.groovyAPI) {
        if (groovyAPI.isShowingNotifications()) {
            $('.container').animate({ 'margin-top': "8%" }, 800);
        } else {
            $('.container').animate({ 'margin-top': clockPositionFromTop }, 800);
        }
    }

    $('.container').css('margin-top', clockPositionFromTop);
}

setInterval(updateClock, 1000);

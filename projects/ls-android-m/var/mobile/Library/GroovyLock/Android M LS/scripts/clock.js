/******************************************
* Author: tcrawford (/u/superp0s)
* Creation Date: 7.18.15
* Description: Creates a simple Android M 
* inspired clock with the date that gets 
* updated every second (1000 ms)
******************************************/

function updateClock() {
    // Get the current hours, and minutes
    var now = new Date();
    var hours24 = now.getHours();
    var hours12 = now.getHours();
    var minutes = now.getMinutes();
    var day = now.getDay();
    var month = now.getMonth();
    var numDay = now.getDate();

    // If the twelve hour time is greater than 12, subtract 12
    hours12 = (hours12 > 12) ? hours12 - 12 : hours12;
    hours12 = (hours12 === 0) ? 12 : hours12;

    // If the number of minutes is '8', then make it '08'
    if (minutes < 10) {
        minutes = '0' + minutes;
    }

    // Set by config.js (configuration file for users)
    if (twentyFourHourTime === true) {
        var time = hours24 + ':' + minutes;
    } else {
        var time = hours12 + ":" + minutes;
    }
    
    dayArray = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
    monthArray = ["January","Febuary","March","April","May","June","July","August","September","October","November","December"];
    
    var nowDate = dayArray[day] + ", " + monthArray[month] + " " + numDay;

    document.getElementById('clock').style.fontFamily = clockFont;
    document.getElementById('date').style.fontFamily = dateFont;
    document.getElementById('clock').style.color = timeColor;
    document.getElementById('clock').innerHTML = time;
    document.getElementById('date').style.color = dateColor;
    document.getElementById('date').innerHTML = nowDate;

    // Widget position from the topof the screen
    $('html').css('top', clockPosFromTop + "px");
}

setInterval(updateClock, 1000);
updateClock();

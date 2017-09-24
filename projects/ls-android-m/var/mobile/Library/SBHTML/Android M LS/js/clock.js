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
    var time = "";

    // If the twelve hour time is greater than 12, subtract 12
    hours12 = (hours12 > 12) ? hours12 - 12 : hours12;
    hours12 = (hours12 === 0) ? 12 : hours12;

    // If the number of minutes is '8', then make it '08'
    if (minutes < 10) {
        minutes = '0' + minutes;
    }

    // Set by config.js (configuration file for users)
    if (twentyFourHourTime) {
        time = hours24 + ':' + minutes;
    } else {
        time = hours12 + ":" + minutes;
    }

    dayArray = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
    monthArray = ["January","Febuary","March","April","May","June","July","August","September","October","November","December"];

    var nowDate = dayArray[day] + ", " + monthArray[month] + " " + numDay;

    // Gets the device width to center the widget
    var deviceWidth = (window.innerWidth > 0) ? window.innerWidth : screen.width;

    // $('.container').css("width", deviceWidth);
    $('.date').css("text-transform", dateTextTransform);
    $('.date').css("font-family", dateFont);
    $('.date').css("font-size", dateFontSize);
    $('.date').css("color", dateColor);
    $('.date').text(nowDate);
    $('.clock').css("font-size", clockFontSize);
    $('.clock').css("font-family", clockFont);
    $('.clock').css("color", timeColor);
    $('.clock').text(time);

    // Widget position from the topof the screen
    $('.container').css("margin-top", clockPositionFromTop + "px");
}

setInterval(updateClock, 1000);

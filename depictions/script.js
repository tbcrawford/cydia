$(document).ready(function() {
    // Get the packageID from the URL
    var packageID = getParameterByName("p");
    var deviceVersion = navigator.userAgent;

    // If no packageID is available, display an error message
    if (!packageID) {
        $(".package-error").text("This package doesn't seem to exist!").css("display", "block");
        $(".package-name").text("Not Found").css("color", "red");
        return;
    }

    // Get information from the JSON file
    $.getJSON("packages/" + packageID + ".json", function(data) {
        document.title = data.name + " by " + data.author;
        $(".package-name").text(data.name);
        $(".package-desc").text(data.description);
        $(".latest-version").text(data.version);
        $(".package-author").text(" by " + data.author);

        var cList = $(".changelog-list");
        var changes = data.changelog[data.version];
        for (var c in changes) {
            var change = changes[c];
            cList.append("<li><p>" + change + "</p></li>")
        }

        $(".screenshots-header").click(function() {
            $(".screenshots").slideToggle(function() {
            });
            $(".rotate").toggleClass("down");
        });

        var count = 0;
        var screenshots = data.screenshots;
        if (screenshots) {
            var sKeys = Object.keys(screenshots);
            for (var s in sKeys) {
                var screenshot = sKeys[s];
                if (count % 2 === 0) {
                    $(".screenshots").append("<div class=\"subshots col-xs-12\"></div>");
                }
                // $(".screenshots .subshots:last-child").append("<div class=\"col-xs-6\"><img class=\"img-responsive\" src=\"screenshots/" + packageID + "/" + screenshot + "\" title=\"" + screenshots[screenshot] + "\"><p>" + screenshots[screenshot] + "</p><br></div>");
                $(".screenshots .subshots:last-child").append("<div class=\"col-xs-6\"><a href=\"screenshots/" + packageID + "/" + screenshot + "\" target=\"_blank\"><img class=\"img-responsive\" src=\"screenshots/" + packageID + "/" + screenshot + "\" title=\"" + screenshots[screenshot] + "\"></a><p>" + screenshots[screenshot] + "</p><br></div>");
                count += 1;
            }
        }

        $(".fullchangelog-header").click(function() {
            $(".fullchangelog").slideToggle(function() {
            });
            $(".turn").toggleClass("left");
        });

        var latest = data.version;
        var versions = Object.keys(data.changelog).reverse();
        for (var v in versions) {
            var version = versions[v];
            var card = $("<div class=\"card remove-space\"></div>");
            card.append(" <div class=\"card-header\">" + version + "</div>");
            card.append(" <div class=\"card-block changelog-list\"></div>");
            if (version === latest) {
                card.find(".card-header").append(" <div class=\"label label-pill label-info latest-version\">Current Version</div>");
            }
            var changes = data.changelog[version];
            for (var c in changes) {
                var change = changes[c];
                card.find(".changelog-list").append("<li><p>" + change + "</p></li>");
            }
            $(".package-versions").append(card);
        }
    })
    .fail(function() {
        $(".package-error").text("An error occurred while retrieving package info!").css("display", "block");
        $(".package-name").text("Repository Error").css("color", "red");
        return;
    });
    function getParameterByName(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
        return results === null ? null : decodeURIComponent(results[1].replace(/\+/g, " "));
    }
});

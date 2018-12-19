(function ($) {

    $.fn.gridviewFix = function () {

        this.filter("table").each(function () {
            var gridview = $(this);

            gridview.find("tbody").before("<thead><tr></tr></thead>");
            gridview.find("thead tr").append(gridview.find("th"));
            gridview.find("tbody tr:first").remove();

        });

        return this;

    };

}(jQuery));
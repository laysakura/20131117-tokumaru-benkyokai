(function (document, $) {
    $(function () {
        "use strict";

        var xsrf_token = getXSRFToken();
        $("form").each(function () {
            var form = $(this);
            var method = form.attr('method');
            if (method === 'get' || method === 'GET') {
                return;
            }

            var input = $(document.createElement('input'));
            input.attr('type',  'hidden');
            input.attr('name',  'XSRF-TOKEN');
            input.attr('value',  xsrf_token);
            form.prepend(input);
        });

        function getXSRFToken() {
            var cookies = document.cookie.split(/\s*;\s*/);
            for (var i=0,l=cookies.length; i<l; i++) {
                var matched = cookies[i].match(/^XSRF-TOKEN=(.*)$/);
                if (matched) {
                    return matched[1];
                }
            }
            return undefined;
        }
    });
})(document, jQuery);

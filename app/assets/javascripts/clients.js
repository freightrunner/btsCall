var app = window.app = {};

app.Clients = function() {
    this._input = $('clients-search-txt');
    this._initAutocomplete();
};

app.Clients.prototype = {
    _initAutocomplete: function() {
        this._input
            .autocomplete({
                source: '/clients/search',
                appendTo: '#clients-search-results',
                select: $.proxy(this._select, this)
            })
            .autocomplete('instace')._renderItem = $.proxy(this._render, this);
    },
    
    _render: function(ul, item) {
        var markup = [
            '<span class="name"> + item.name + </span>',
            '<span class="address"> + item.address + </span>'
        ];
        return $('<li>')
            .append(markup.join(''))
            .appendTo(ul);
    },
    
    _select: function(e, ui) {
        this._input.val(ui.item.name + ' - ' + ui.item.address);
        return false;
    }
};
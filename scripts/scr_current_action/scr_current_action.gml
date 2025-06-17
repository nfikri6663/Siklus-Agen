function scr_current_action() {
    var _panel_x2 = 270;
    var _panel_y2 = 10;
    var _col_width = 100;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_panel_x2 + (_col_width*3)/2+2, _panel_y2, "== AKSI TERSEDIA (KONDISI SAAT INI) ==");

    _panel_y2 += _line_height * 1.5;

    var _pagi_actions  = get_valid_actions("pagi");
    var _siang_actions = get_valid_actions("siang");
    var _malam_actions = get_valid_actions("malam");

    var _header_y = _panel_y2;
    var _x_pagi = _panel_x2;
    var _x_siang = _x_pagi + _col_width;
    var _x_malam = _x_siang + _col_width;

    // Header per waktu
    draw_set_color(time_of_day == "pagi" ? c_yellow : c_white);
    draw_text(_x_pagi + _col_width/2, _header_y, "PAGI");

    draw_set_color(time_of_day == "siang" ? c_yellow : c_white);
    draw_text(_x_siang + _col_width/2, _header_y, "SIANG");

    draw_set_color(time_of_day == "malam" ? c_yellow : c_white);
    draw_text(_x_malam + _col_width/2, _header_y, "MALAM");

    _panel_y2 += _line_height * 0.6;
    draw_set_color(c_white);
    draw_line(_panel_x2, _panel_y2, _panel_x2 + (_col_width*3), _panel_y2);
    _panel_y2 += _line_height * 0.6;

    var _max_rows = max(array_length(_pagi_actions), array_length(_siang_actions), array_length(_malam_actions));

    for (var i = 0; i < _max_rows; i++) {
        draw_action_text(_x_pagi + _col_width/2,  _panel_y2, _pagi_actions,  i, time_of_day == "pagi");
        draw_action_text(_x_siang + _col_width/2, _panel_y2, _siang_actions, i, time_of_day == "siang");
        draw_action_text(_x_malam + _col_width/2, _panel_y2, _malam_actions, i, time_of_day == "malam");
        _panel_y2 += _line_height;
    }

    draw_set_valign(fa_top);
}

function draw_action_text(_x, _y, _actions, _index, _highlight) {
    if (_index < array_length(_actions)) {
        var _enum = _actions[_index];
        if (_enum >= 0 && _enum < array_length(action_names)) {
            draw_set_color(_highlight ? c_lime : c_white);
            draw_text(_x, _y, action_names[_enum]);
        }
    }
}

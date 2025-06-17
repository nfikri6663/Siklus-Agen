function scr_q_table() {
    var _selected_time_string = 0;
    var _q_values_to_show = [];
    var _valid_actions_for_view = 0;
    var _clean_state_text = "";
    var _last_drawn_time = "";

    // Ambil state terakhir yang valid dari log
    for (var i = 0; i < array_length(current_day_log); i++) {
        var _entry = current_day_log[i];
        if (variable_struct_exists(_entry, "time_of_day") && _entry.time_of_day != _last_drawn_time) {
            var _full_state_text = variable_struct_exists(_entry, "state_key_at_the_time") ? _entry.state_key_at_the_time : "STATE TIDAK DIKETAHUI";
            var _last_underscore_pos = string_last_pos("_", _full_state_text);
            _clean_state_text = string_copy(_full_state_text, 1, _last_underscore_pos - 1);
            _selected_time_string = _entry.time_of_day;
            _last_drawn_time = _entry.time_of_day;
        }
    }

    var _draw_x = _panel_x;
    var _draw_y = _panel_y + 10;

    // Header
    draw_set_color(c_white);
    draw_text(_draw_x, _draw_y, "Q-TABLE VIEWER");
    _draw_y += _line_height;

    draw_set_color(c_gray);
    draw_text(_draw_x, _draw_y, "Gunakan Panah Kiri/Kanan untuk ganti waktu");
    _draw_y += _line_height;

    // State key info
    draw_set_color(c_white);
    var _base_state_text = game_phase == "manual_play" ? _clean_state_text : current_state_key;
    draw_text(_draw_x, _draw_y, "State: " + _base_state_text);
    var _text_width = string_width("State: " + _base_state_text);

    draw_set_color(c_yellow);
    if game_phase != "auto_learning" {
        draw_text(_draw_x + _text_width, _draw_y, string_upper(_selected_time_string));
    }
    _draw_y += _line_height * 1.5;

    // Header tabel
    draw_set_color(c_white);
    draw_text(_draw_x + 10, _draw_y, "Aksi");
    draw_text(_draw_x + 150, _draw_y, "Pagi");
    draw_text(_draw_x + 230, _draw_y, "Siang");
    draw_text(_draw_x + 310, _draw_y, "Malam");
    _draw_y += _line_height;
    draw_line(_draw_x, _draw_y, _draw_x + 400, _draw_y);
    _draw_y += _line_height * 0.5;

    // Siapkan rekomendasi aksi terbaik per waktu
    var _recommended_per_time = array_create(3, -1);
    var _max_q_per_time = array_create(3, -99999);

    for (var t = 0; t < 3; t++) {
        var _time_label = time_of_day_map[t];
        var _full_state_key = _clean_state_text + "_" + _time_label;
        var _q_array = q_table[? _full_state_key];

        if (is_array(_q_array)) {
            for (var a = 0; a < array_length(_q_array); a++) {
                if (_q_array[a] > _max_q_per_time[t]) {
                    _max_q_per_time[t] = _q_array[a];
                    _recommended_per_time[t] = a;
                }
            }
        }
    }

    // Tampilkan baris tabel aksi vs q-value semua waktu
    for (var i = 0; i < ACTIONS._count; i++) {
        if (i >= array_length(action_names)) continue;
        var _action_name = action_names[i];
        draw_set_color(c_white);
        draw_text(_draw_x + 10, _draw_y, _action_name);

        for (var t = 0; t < 3; t++) {
            var _time_label = time_of_day_map[t];
            var _full_state_key = _clean_state_text + "_" + _time_label;

            var _q_array = q_table[? _full_state_key];
            var _q_value = (is_array(_q_array) && array_length(_q_array) > i) ? _q_array[i] : 0;

            // Warnai nilai terbaik biru, sisanya sesuai nilai
            if (i == _recommended_per_time[t]) {
                draw_set_color(c_aqua);
            } else {
                draw_set_color((_q_value > 0) ? c_lime : ((_q_value < 0) ? c_red : c_gray));
            }

            draw_set_halign(fa_right);
            draw_text(_draw_x + 150 + t * 80, _draw_y, string_format(_q_value, 1, 4));
            draw_set_halign(fa_left);
        }

        _draw_y += _line_height;
    }
}

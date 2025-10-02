function scr_q_table(){
    var _panel_x = 10
    var _panel_y = 300
    var _line_height = 20
    
    // --- Ambil data Q-Value dan Aksi Valid historis dari log ---
    var _q_log_pagi = undefined, _valid_actions_pagi = undefined
    var _q_log_siang = undefined, _valid_actions_siang = undefined
    var _q_log_malam = undefined, _valid_actions_malam = undefined
    
    for (var i = 0; i < array_length(current_day_log); i++){
        var _entry = current_day_log[i]
        if variable_struct_exists(_entry, "q_values_at_the_time"){
            if _entry.time_of_day == "pagi"{
                _q_log_pagi = _entry.q_values_at_the_time
                if variable_struct_exists(_entry, "valid_actions_at_the_time") _valid_actions_pagi = _entry.valid_actions_at_the_time
            }
            if _entry.time_of_day == "siang"{
                _q_log_siang = _entry.q_values_at_the_time
                if variable_struct_exists(_entry, "valid_actions_at_the_time") _valid_actions_siang = _entry.valid_actions_at_the_time
            }
            if _entry.time_of_day == "malam"{
                _q_log_malam = _entry.q_values_at_the_time
                if variable_struct_exists(_entry, "valid_actions_at_the_time") _valid_actions_malam = _entry.valid_actions_at_the_time
            }
        }
    }
    
    var q_log_map = [_q_log_pagi, _q_log_siang, _q_log_malam]
    var valid_actions_map = [_valid_actions_pagi, _valid_actions_siang, _valid_actions_malam]
    
    var _clean_state_text = ""
    var _full_current_state = current_state_key != "Inisialisasi..." ? current_state_key : all_possible_states[0]
    var _last_underscore_pos = string_last_pos("_", _full_current_state)
    if _last_underscore_pos > 0 _clean_state_text = string_copy(_full_current_state, 1, _last_underscore_pos - 1)
    else _clean_state_text = "STATE_INVALID"
    
    var _best_action_log = array_create(3, -1)
    var _max_q_log = array_create(3, -999999)
    var _best_action_live = array_create(3, -1)
    var _max_q_live = array_create(3, -999999)
    
    for (var i = 0; i < 3; i++){
        var _q_array_log = q_log_map[i]
        var _valid_actions_list = valid_actions_map[i]
        var _full_state_key = _clean_state_text + "_" + time_of_day_map[i]
        var _q_array_live = q_table[? _full_state_key]
        
        //Mencari rekomendasi Q-Value dari data Log
        if is_array(_q_array_log) && is_array(_valid_actions_list){
            for (var j = 0; j < array_length(_valid_actions_list); j++){
                var _action_enum = _valid_actions_list[j]
                if _q_array_log[_action_enum] > _max_q_log[i]{
                    _max_q_log[i] = _q_array_log[_action_enum]
                    _best_action_log[i] = _action_enum
                }
            }
        }
        
        //Mencari rekomendasi Q-Value dari data Live
        if is_array(_q_array_live){
            for (var j = 0; j < array_length(_q_array_live); j++){
                if _q_array_live[j] > _max_q_live[i]{
                    _max_q_live[i] = _q_array_live[j]
                    _best_action_live[i] = j
                }
            }
        }
    }
    
    var _draw_x = _panel_x
    var _draw_y = _panel_y + 30
    draw_set_color(c_white)
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    var _table_width = 560
    draw_text(_draw_x + _table_width / 2, _draw_y, "== Q-TABLE ==")
    
    _draw_y += _line_height * 1.5
    draw_set_halign(fa_left)
    draw_set_font(fnt_info)
    draw_text(_draw_x + 10, _draw_y, "Aksi")
    draw_text(_draw_x + 140, _draw_y, "Pagi (Live / Log)")
    draw_text(_draw_x + 280, _draw_y, "Siang (Live / Log)")
    draw_text(_draw_x + 420, _draw_y, "Malam (Live / Log)")
    
    _draw_y += _line_height
    draw_line(_draw_x, _draw_y, _draw_x + _table_width, _draw_y)
    _draw_y += _line_height
    
    for (var i = 0; i < ACTIONS._count; i++){
        if i >= array_length(action_names) continue
        var _action_name = action_names[i]
        draw_set_color(c_white)
        draw_text(_draw_x + 10, _draw_y, _action_name)
        for (var j = 0; j < 3; j++){
            var _x_pos = _draw_x + 140 + (j * 140)
            var _full_state_key = _clean_state_text + "_" + time_of_day_map[j]
            
            var _q_array_live = q_table[? _full_state_key]
            var _q_live = is_array(_q_array_live) && array_length(_q_array_live) > i ? _q_array_live[i] : 0
            if i == _best_action_live[j] draw_set_color(c_yellow)
            else if _q_live < 0 draw_set_color(c_red)
            else draw_set_color(c_aqua)
            draw_text(_x_pos, _draw_y, string_format(_q_live, 1, 2))
            
            var _q_array_log = q_log_map[j]
            var _q_log = is_array(_q_array_log) && array_length(_q_array_log) > i ? _q_array_log[i] : 0
            if i == _best_action_log[j] draw_set_color(c_orange)
            else if _q_log < 0 draw_set_color(c_red)
            else draw_set_color(c_gray)
            draw_text(_x_pos + 60, _draw_y, string_format(_q_log, 1, 2))
        }
        _draw_y += _line_height
    }
}
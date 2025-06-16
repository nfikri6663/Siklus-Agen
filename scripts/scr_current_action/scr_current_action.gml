function scr_current_action(){
    var _panel_x2 = 270;
    var _panel_y2 = 10;
    var _col_width = 100; // Lebar setiap kolom waktu
    
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(_panel_x2 + (_col_width*3)/2+2, _panel_y2, "== AKSI TERSEDIA (KONDISI SAAT INI) ==");
    _panel_y2 += _line_height * 1.5;
    
    // 1. Ambil daftar aksi valid untuk setiap waktu menggunakan fungsi baru kita
    var _pagi_actions = get_valid_actions("pagi");
    var _siang_actions = get_valid_actions("siang");
    var _malam_actions = get_valid_actions("malam");
    
    // 2. Gambar header untuk setiap kolom waktu
    var _header_y = _panel_y2;
    var _x_pagi = _panel_x2;
    var _x_siang = _panel_x2 + _col_width;
    var _x_malam = _panel_x2 + _col_width * 2;
    
    draw_set_valign(fa_middle);
    // Beri sorotan pada header untuk waktu yang sedang berjalan saat ini
    if (time_of_day == "pagi") draw_set_color(c_yellow); else draw_set_color(c_white);
    draw_text(_x_pagi + _col_width/2, _header_y, "PAGI");
    
    if (time_of_day == "siang") draw_set_color(c_yellow); else draw_set_color(c_white);
    draw_text(_x_siang + _col_width/2, _header_y, "SIANG");
    
    if (time_of_day == "malam") draw_set_color(c_yellow); else draw_set_color(c_white);
    draw_text(_x_malam + _col_width/2, _header_y, "MALAM");
    
    _panel_y2 += _line_height*0.6
    draw_set_color(c_white);
    draw_line(_panel_x2, _panel_y2, _panel_x2 + (_col_width*3), _panel_y2);
    _panel_y2 += _line_height * 0.6;
    
    // 3. Tentukan jumlah baris terbanyak untuk loop
    var _max_rows = max(array_length(_pagi_actions), array_length(_siang_actions), array_length(_malam_actions));
    
    // 4. Loop dan gambar aksi untuk setiap kolom
    for (var i = 0; i < _max_rows; i++) {
        // Kolom Pagi
        if (i < array_length(_pagi_actions)) {
            var _action_enum = _pagi_actions[i];
            draw_text(_x_pagi + _col_width/2, _panel_y2, action_names[_action_enum]);
        }
        
        // Kolom Siang
        if (i < array_length(_siang_actions)) {
            var _action_enum = _siang_actions[i];
            draw_text(_x_siang + _col_width/2, _panel_y2, action_names[_action_enum]);
        }
    
        // Kolom Malam
        if (i < array_length(_malam_actions)) {
            var _action_enum = _malam_actions[i];
            draw_text(_x_malam + _col_width/2, _panel_y2, action_names[_action_enum]);
        }
        
        _panel_y2 += _line_height;
    }
    
    // Kembalikan perataan default
    draw_set_valign(fa_top);
}
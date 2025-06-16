function scr_q_table(){
    // 1. Ambil semua kategori stat agen saat ini (kecuali waktu)
    var _health_cat = (health > 70) ? "tinggi" : ((health > 30) ? "sedang" : "rendah");
    var _hungry_cat = (hungry > 70) ? "SangatLapar" : ((hungry > 50) ? "lapar" : "kenyang");
    var _energy_cat = (energy > 70) ? "tinggi" : ((energy > 30) ? "sedang" : "rendah");
    var _money_cat = (money > 300) ? "kaya" : ((money > 100) ? "cukup" : "miskin");
    var _age_cat = (age <= 5) ? "bayi" : ((age <= 12) ? "anak" : ((age <= 22) ? "remaja" : ((age <= 60) ? "dewasa" : "tua")));
    
    // 2. Ambil string waktu yang DIPILIH dari viewer
    var _selected_time_string = time_of_day_map[q_viewer_time_index];
    
    // 3. Gabungkan menjadi satu state key target untuk ditampilkan
    var _target_state_key = $"{_age_cat}_{_health_cat}_{_hungry_cat}_{_energy_cat}_{_money_cat}_{_selected_time_string}";
    
    // Ambil nilai-nilai Q untuk state target tersebut
    var _q_values_to_show = q_table[? _target_state_key];
    
    // --- Mulai Menggambar ---
    var _draw_x = _panel_x;
    var _draw_y = _panel_y+10;
    
    // Gambar Judul dan Instruksi
    draw_set_color(c_white);
    draw_text(_draw_x, _draw_y, "Q-TABLE VIEWER");
    _draw_y += _line_height;
    draw_set_color(c_gray);
    draw_text(_draw_x, _draw_y, "Gunakan Panah Kiri/Kanan untuk ganti waktu");
    _draw_y += _line_height;
    
    // Tampilkan state yang sedang diinspeksi, beri warna pada waktunya
    draw_set_color(c_white);
    var _base_state_text = game_phase == "auto_learning" ? current_state_key : $"{_age_cat}_{_health_cat}_{_energy_cat}_{_money_cat}_";
    draw_text(_draw_x, _draw_y, "State: " + _base_state_text);
    var _text_width = string_width("State: " + _base_state_text);
    draw_set_color(c_yellow);
    if game_phase != "auto_learning" draw_text(_draw_x + _text_width, _draw_y, string_upper(_selected_time_string));
    _draw_y += _line_height * 1.5;
    
    if (is_undefined(_q_values_to_show)) {
        _q_values_to_show = array_create(ACTIONS._count, 0);
        
        // Beri catatan tambahan bahwa ini adalah state baru
        draw_set_color(c_gray);
        draw_text(_draw_x, _draw_y, "Agen belum pernah mengalami situasi ini");
        _draw_y += _line_height;
    }
    
    // --- Gambar Tabel ---
    // Header Tabel
    draw_set_color(c_white);
    draw_text(_draw_x+10, _draw_y, "Aksi");
    draw_text(_draw_x + 150, _draw_y, "Q-Value");
    _draw_y += _line_height;
    draw_line(_draw_x, _draw_y, _draw_x + 210, _draw_y);
    _draw_y += _line_height*0.5;
    
    // Cari Q-Value tertinggi untuk ditandai sebagai rekomendasi
    var _max_q = -99999; // Mulai dengan angka sangat kecil
    var _recommended_action_index = -1;
    for (var i = 0; i < array_length(_q_values_to_show); i++) {
        if (_q_values_to_show[i] > _max_q) {
            _max_q = _q_values_to_show[i];
            _recommended_action_index = i;
        }
    }
    
    // Loop dan gambar setiap baris tabel
    for (var i = 0; i < ACTIONS._count; i++) {
        var _action_name = action_names[i];
        var _q_value = _q_values_to_show[i];
        
        var _text_color = c_white;
        // Tandai aksi yang direkomendasikan dengan warna aqua
        if (i == _recommended_action_index) {
            _text_color = c_aqua;
        }
        
        // Gambar Nama Aksi
        draw_set_color(_text_color);
        draw_text(_draw_x+10, _draw_y, _action_name);
        
        // Gambar Nilai Q dengan warna berdasarkan positif/negatif
        var _value_color = (_q_value > 0) ? c_lime : c_red;
        if (_q_value == 0) _value_color = c_gray;
        
        draw_set_color(_value_color);
        draw_set_halign(fa_right)
        draw_text(_draw_x + 200, _draw_y, string_format(_q_value, 1, 4));
        draw_set_halign(fa_left)
        
        _draw_y += _line_height;
    }
}
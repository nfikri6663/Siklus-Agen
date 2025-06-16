function scr_report_table(){
    var _report_x = 620; // Sesuaikan posisi X awal jika perlu
    var _report_y = 10;
    // --- Definisi Geometri & Posisi Kolom Tabel ---
    var _row_height = 38;
    _x_title    = _report_x;                      // Kolom Judul Aksi (Lebar: 240px)
    _x_health   = _report_x + 190;                  // Kolom delta Health
    _x_hungry   = _report_x + 250;                  // Kolom delta Hungry
    _x_energy   = _report_x + 310;                  // Kolom delta Energy
    _x_stress   = _report_x + 370;                  // Kolom delta Stress
    _x_social   = _report_x + 430;                  // Kolom delta Social
    _x_money    = _report_x + 490;                  // Kolom delta Money
    _x_iq       = _report_x + 550;                  // Kolom delta IQ
    _x_reward   = _report_x + 610;                  // Kolom Reward/Punish
    _x_qvalue   = _report_x + 690;                  // Kolom Q-Value
    _table_end_x = _x_qvalue + 50;
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_x_title + (_table_end_x - _x_title)/2, _report_y, "== LAPORAN HARI KE-" + string(max(0, days_passed)) + " ==");

    _report_y += _line_height * 1.5;
    draw_set_valign(fa_middle); // Set perataan vertikal ke tengah untuk semua teks
    // --- Menggambar Header Tabel (2 Tingkat) ---
    var _header_y = _report_y;
    draw_text(_x_title + 190/2, _header_y, "Kejadian");
    draw_text((_x_health + _x_iq)/2, _header_y, "Perubahan Stat");
    draw_text(_x_reward, _header_y, "Reward/\nPunish");
    draw_text(_x_qvalue, _header_y, "Q-Value");
    
    _header_y += _line_height;
    //draw_set_font_size(10); // Gunakan font lebih kecil untuk sub-header
    draw_text(_x_health, _header_y, "Health");
    draw_text(_x_hungry, _header_y, "Hungry");
    draw_text(_x_energy, _header_y, "Energy");
    draw_text(_x_stress, _header_y, "Stress");
    draw_text(_x_social, _header_y, "Social");
    draw_text(_x_money, _header_y, "Money");
    draw_text(_x_iq, _header_y, "IQ");
    //draw_set_font_size(-1); // Kembalikan ke ukuran font default
    
    _report_y += _line_height * 2;
    draw_line(_report_x, _report_y, _table_end_x, _report_y); // Garis bawah header
    _report_y += 8;

    // --- Fungsi Pembantu untuk menggambar SATU BARIS PENUH laporan ---
    var _draw_report_row = function(yy, title_text, result, q_val, title_color) {
        _yy = yy
        res = result
        draw_set_halign(fa_left);
        draw_set_color(title_color);
        draw_text_ext(_x_title, _yy, title_text, 16, 210);
        
        if (!is_struct(res)) return; // Penjaga jika data tidak valid
        // Helper kecil untuk gambar delta
        var _draw_delta = function(xx, stat_name, mirror_color=false) {
            if (variable_struct_exists(res, stat_name)) {
                var value = res[$ stat_name];
                var str = value != 0 ? ((value > 0 ? "+" : "") + string(value)) : value;
                var color = value != 0 ? (!mirror_color ? ((value > 0) ? c_lime : c_red) : ((value < 0) ? c_lime : c_red)) : c_dkgray;
                draw_set_halign(fa_center);
                draw_set_color(color);
                draw_text(xx, _yy, str);
            }
        };
        
        // Gambar semua delta sesuai urutan yang diminta
        _draw_delta(_x_hungry, "delta_hungry", true);
        _draw_delta(_x_health, "delta_health");
        _draw_delta(_x_energy, "delta_energy");
        _draw_delta(_x_stress, "delta_stress", true);
        _draw_delta(_x_social, "delta_social");
        _draw_delta(_x_money, "delta_money");
        _draw_delta(_x_iq, "delta_iq");
        // Gambar Reward & Punishment
        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(_x_reward, _yy, string(max(0, result.reward)) + " / " + string(min(0, result.reward)));
        // Gambar Q-Value
        draw_set_color(c_orange);
        draw_text(_x_qvalue, _yy, string_format(q_val, 1, 2));
    };
    
    // --- Loop Utama Laporan ---
    var _last_drawn_time = ""; 
    for (var i = 0; i < array_length(current_day_log); i++) {
        var _entry = current_day_log[i];
        // Gambar Header Waktu
        if (variable_struct_exists(_entry, "time_of_day") && _entry.time_of_day != _last_drawn_time) {
            _report_y += _line_height * 0.5;
            var _full_state_text = variable_struct_exists(_entry, "state_key_at_the_time") ? _entry.state_key_at_the_time : "STATE TIDAK DIKETAHUI";
            // --- Logika untuk memotong bagian waktu dari teks ---
            var _last_underscore_pos = string_last_pos("_", _full_state_text);
            var _clean_state_text = string_copy(_full_state_text, 1, _last_underscore_pos - 1);
            var _header_text = $"--- {string_upper(_entry.time_of_day)}: {_clean_state_text} ---";
            draw_set_halign(fa_center);
            draw_set_color(c_yellow);
            draw_text(_x_title + (_table_end_x - _x_title)/2, _report_y, _header_text);
            _report_y += _line_height * 1.5;
            _last_drawn_time = _entry.time_of_day;
        }
        
        // --- Ambil semua data dengan aman ---
        var _nama_aksi = variable_struct_exists(_entry, "action_name") ? _entry.action_name : "N/A";
        var _hasil_aksi = variable_struct_exists(_entry, "action_result") ? _entry.action_result : 0;
        var _learning_details = variable_struct_exists(_entry, "learning_details") ? _entry.learning_details : 0;
        var _q_diambil = is_struct(_learning_details) ? _learning_details.past_q : 0;
        
        var _rekomendasi_struct = variable_struct_exists(_entry, "recommendation") ? _entry.recommendation : 0;
        var _nama_rekomendasi = is_struct(_rekomendasi_struct) ? _rekomendasi_struct.name : "N/A";
        var _alasan_rekomendasi = is_struct(_rekomendasi_struct) ? _rekomendasi_struct.reason : "-";
        var _hasil_rekomendasi = is_struct(_rekomendasi_struct) ? _rekomendasi_struct.result_struct : 0;
        var _q_rekomendasi = is_struct(_rekomendasi_struct) ? _rekomendasi_struct.q_value : 0;
        var _nama_lengkap_rekomendasi = _nama_rekomendasi + "\n(" + _alasan_rekomendasi + ")";
        
        // --- Panggil fungsi gambar untuk setiap baris ---
        _draw_report_row(_report_y, "Aksi: " + _nama_aksi, _hasil_aksi, _q_diambil, c_white);
        _draw_report_row(_report_y + _row_height, "Rekomendasi: " + _nama_lengkap_rekomendasi, _hasil_rekomendasi, _q_rekomendasi, c_aqua);
        
        _report_y += _row_height * 2 + 8;
        draw_line(_report_x, _report_y, _table_end_x, _report_y);
        _report_y += 8;
    }
    
    // Kembalikan perataan default
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
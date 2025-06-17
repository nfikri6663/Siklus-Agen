draw_self();
draw_set_font(fnt_info); 
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

scr_status_agent()
scr_current_action()
scr_report_table()
scr_q_table()

var _status_text = "";
var _status_color = c_white;

if (game_phase == "auto_learning") {
    _status_text = $"FASE BELAJAR OTOMATIS... STEP: {step_training[step_num]}/{_training_cycles} PUTARAN: {step_num+1}/{array_length(step_training)}";
    _status_color = c_aqua;
} else if (game_phase == "manual_play") {
    if (is_simulating) {
        _status_text = "MODE SIMULASI MANUAL (BERJALAN)";
        _status_color = c_lime;
    } else {
        _status_text = "SIAP DIMULAI | Tekan Spasi untuk MEMULAI SIMULASI";
        _status_color = c_yellow;
    }
}

// Gambar teks status di bagian atas layar
draw_set_halign(fa_center);
draw_set_color(_status_color);
draw_text(display_get_gui_width()/2, display_get_gui_height()-48, _status_text);
draw_set_halign(fa_left);
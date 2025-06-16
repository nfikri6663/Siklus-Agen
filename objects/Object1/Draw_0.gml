draw_self();

// =======================================================
// --- Pengaturan Teks ---
// =======================================================
draw_set_font(fnt_info); 
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

scr_status_agent()
scr_current_action()
scr_report_table()
scr_text_simulating()
scr_q_table()

var _status_text = "";
var _status_color = c_white;

if (game_phase == "auto_learning") {
    _status_text = "FASE BELAJAR OTOMATIS... (Hari ke-" + string(days_passed + 1) + "/100)";
    _status_color = c_aqua;
} else if (game_phase == "manual_play") {
    if (is_simulating) {
        _status_text = "MODE SIMULASI MANUAL (BERJALAN)";
        _status_color = c_lime;
    } else {
        _status_text = "SIAP DIMULAI | Tekan Spasi untuk Play/Pause";
        _status_color = c_yellow;
    }
}

// Gambar teks status di bagian atas layar
draw_set_halign(fa_center);
draw_set_color(_status_color);
draw_text(display_get_gui_width()/2, display_get_gui_width()-64, _status_text);
draw_set_halign(fa_left);

if keyboard_check_pressed(ord("1")) num = 0
if keyboard_check_pressed(ord("2")) num = 1
if keyboard_check_pressed(ord("3")) num = 2
if keyboard_check_pressed(ord("4")) num = 3
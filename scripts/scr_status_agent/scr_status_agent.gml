function scr_status_agent(){
    _panel_x = 10
    _panel_y = 10
    _line_height = 24
    var _panel_width = 220
    _col_label_x = _panel_x + 10
    _col_value_x = _panel_x + 120
    _bar_width = 90
    
    draw_set_color(c_black)
    draw_set_alpha(0.6)
    draw_rectangle(_panel_x - 5, _panel_y - 5, _panel_x + _panel_width + 5, _panel_y + (_line_height * 10), false)
    draw_set_alpha(1.0)
    
    draw_set_valign(fa_top)
    draw_set_color(c_white)
    draw_set_halign(fa_center)
    draw_text(_panel_x + _panel_width/2, _panel_y, "== STATUS AGEN ==")
    _panel_y += _line_height * 1.5
    draw_set_halign(fa_left)
    
    // --- Fungsi Pembantu untuk menggambar satu baris stat ---
    var _draw_stat_row = function(label, value, max_value, show_bar=false, invert_color=false){
        draw_set_color(c_white)
        draw_set_valign(fa_middle)
        draw_text(_col_label_x, _panel_y, label + ":")
        
        if show_bar{
            var _bar_x = _col_value_x
            var _bar_y = _panel_y - (_line_height/4)
            var _bar_h = _line_height/2
            var _percent = value / max_value
            
            var _bar_color = !invert_color ? make_color_rgb(80, 200, 80) : make_color_rgb(220, 80, 80)
            if !invert_color && _percent < 0.3 _bar_color = c_red
            if invert_color && _percent < 0.3 _bar_color = c_lime
            
            draw_set_color(c_dkgray)
            draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_h, false)
            draw_set_color(_bar_color)
            draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_width * _percent), _bar_y + _bar_h, false)
            
            draw_set_color(c_white)
            var c = c_white
            draw_set_halign(fa_center)
            draw_text_transformed_color(_bar_x + _bar_width/2, _panel_y+1, $"{value} %",0.8,0.8,0,c,c,c,c,1)
            draw_set_halign(fa_left)
        }else{
            draw_set_color(c_white)
            draw_text(_col_value_x, _panel_y, string(value))
        }
        _panel_y += _line_height
    }
    
    _draw_stat_row("Health", string_format(health,   1, 0), 100, true)
    _draw_stat_row("Hungry", string_format(hungry,   1, 0), 100, true, true)
    _draw_stat_row("Energy", string_format(energy,   1, 0), 100, true)
    _draw_stat_row("Stress", string_format(stress,   1, 0), 100, true, true)
    _draw_stat_row("Social", string_format(social,   1, 0), 100, true)
    _draw_stat_row("Money",  string(money),          0, false)
    _draw_stat_row("IQ",     string(iq),             0, false)
    _draw_stat_row("Usia",   string(age) + " tahun", 0, false)
    _draw_stat_row("Hari ke",string(days_passed),    0, false)
    _draw_stat_row("Waktu",  time_of_day,            0, false)
    
    draw_set_valign(fa_top);
}
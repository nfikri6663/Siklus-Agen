function scr_text_simulating(){
    if (!is_simulating) {
        // Ambil ukuran window untuk menempatkan teks di tengah
        var _w = display_get_gui_width();
        var _h = display_get_gui_height()*1.8;
        
        // Gambar kotak semi-transparan sebagai latar belakang
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_rectangle(_w/2 - 200, _h/2 - 40, _w/2 + 200, _h/2 + 40, false);
        draw_set_alpha(1.0); // Kembalikan alpha
        
        // Gambar teks instruksi
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        
        draw_text(_w/2, _h/2 - 15, "SIMULASI DIJEDA");
        draw_text(_w/2, _h/2 + 15, "Tekan SPASI untuk melanjutkan ke hari berikutnya");
        
        // Kembalikan perataan teks ke default
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}
function array_clone_manual(_source_array){
    var _new_array = []
    var _len = array_length(_source_array)
    for (var i = 0; i < _len; i++){
        array_push(_new_array, _source_array[i])
    }
    return _new_array
}

function time_format(_angka){
    if _angka < 10 return $"0{_angka}" else return _angka
}

function time_calc(time){
    var total_menit = floor(time)
    var jam = floor(total_menit / 60)
    var menit = total_menit % 60
    var string_jam = time_format(jam)
    var string_menit = time_format(menit)
    waktu_final_string = $"{string_jam}:{string_menit}"
}

function draw_status(){
    var _status_text = ""
    var _status_color = c_white
    if game_phase == "auto_learning"{
        _status_text = $"FASE BELAJAR OTOMATIS... STEP:  {step_training[step_num]} / {_training_cycles} dengan PUTARAN:  {step_num+1} / {array_length(step_training)}  -  {waktu_final_string}"
        _status_color = c_aqua
    }else{
        if is_simulating{
            _status_text = "MODE SIMULASI MANUAL (BERJALAN)"
            _status_color = c_lime
        }else{
            _status_text = "SIAP DIMULAI | Tekan Spasi untuk MEMULAI SIMULASI"
            _status_color = c_yellow
        }
    }
    
    draw_set_halign(fa_center)
    if health > 0{
        draw_set_color(_status_color)
        draw_text(display_get_gui_width()/2, display_get_gui_height()-48, $"{_status_text}")
        draw_set_color(c_yellow)
        draw_text(display_get_gui_width()/2, display_get_gui_height()-24, $"Epsilon Greedy: {epsilon}")
    }else{
        draw_set_color(c_red)
        draw_text(display_get_gui_width()/2, display_get_gui_height()-48, $"AGEN MENINGGAL pada USIA: {age} tahun")
        draw_set_color(c_aqua)
        draw_text(display_get_gui_width()/2, display_get_gui_height()-24, "-- Tekan 'ENTER' untuk memulai ulang SIMULASI --")
    }
    draw_set_halign(fa_left)
}
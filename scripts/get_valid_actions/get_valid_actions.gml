function get_valid_actions(_time_to_check = time_of_day){
    var _valid_actions = []
    array_push(_valid_actions, ACTIONS.Tidur)
    array_push(_valid_actions, ACTIONS.Makan)
    array_push(_valid_actions, ACTIONS.Bermain)
    array_push(_valid_actions, ACTIONS.Menangis)
    array_push(_valid_actions, ACTIONS.Belajar)
    array_push(_valid_actions, ACTIONS.Istirahat)
    array_push(_valid_actions, ACTIONS.Bekerja)
    array_push(_valid_actions, ACTIONS.Bersosialisasi)
    array_push(_valid_actions, ACTIONS.Olahraga)
    array_push(_valid_actions, ACTIONS.Liburan)
    array_push(_valid_actions, ACTIONS.Menikah)
    array_push(_valid_actions, ACTIONS.Punya_Anak)
    array_push(_valid_actions, ACTIONS.Rawat_Jalan)
    return _valid_actions
}

/*function get_valid_actions(_time_to_check = time_of_day){
    var _valid_actions = []
    if (_time_to_check == "malam" || age <= 5) array_push(_valid_actions, ACTIONS.Tidur)
    array_push(_valid_actions, ACTIONS.Makan)
    if (_time_to_check == "siang") array_push(_valid_actions, ACTIONS.Bermain)
    if (age <= 5) array_push(_valid_actions, ACTIONS.Menangis)
    if (age >= 6 && age <= 22 && _time_to_check == "siang") array_push(_valid_actions, ACTIONS.Belajar)
    if (_time_to_check == "siang" && age >= 18) array_push(_valid_actions, ACTIONS.Istirahat)
    if (age >= 13 && age <= 60) array_push(_valid_actions, ACTIONS.Bekerja)
    if (age >= 6) array_push(_valid_actions, ACTIONS.Bersosialisasi)
    if (age >= 13 && age <= 60 && (_time_to_check == "pagi" || _time_to_check == "siang")){
        array_push(_valid_actions, ACTIONS.Olahraga)
    }
    if (age >= 18 && age <= 60 && _time_to_check == "siang") array_push(_valid_actions, ACTIONS.Liburan)
    if (age >= 25 && age <= 60 && _time_to_check == "siang") array_push(_valid_actions, ACTIONS.Menikah)
    if (age >= 32 && age <= 60) array_push(_valid_actions, ACTIONS.Punya_Anak)
    if (is_sick && _time_to_check == "siang") array_push(_valid_actions, ACTIONS.Rawat_Jalan)
    
    return _valid_actions
}
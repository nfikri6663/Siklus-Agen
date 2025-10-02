function get_recommendation_details(_state_key, _valid_actions) {
    if array_length(_valid_actions) == 0{ //Jika tidak ada array yang valid
        return { name: "Tidak ada", reason: "Tidak ada pilihan", result_struct: 0, q_value: 0 }
    }
    
    var _q_values = q_table[? _state_key]
    if (is_undefined(_q_values)) { //Jika tidak ada State
        var _potential_result = perform_action_and_get_reward(_valid_actions[0], true)
        return { name: action_names[_valid_actions[0]], reason: "mencoba hal baru", result_struct: _potential_result, q_value: 0, action_enum: _valid_actions[0] }
    }
    
    var _best_action_enum = _valid_actions[0]
    var _max_q = _q_values[_best_action_enum]
    for (var i = 1; i < array_length(_valid_actions); i++){
        var _current_action_enum = _valid_actions[i]
        if _q_values[_current_action_enum] > _max_q{
            _max_q = _q_values[_current_action_enum]
            _best_action_enum = _current_action_enum
        }
    }
    
    var _potential_result = perform_action_and_get_reward(_best_action_enum, true)
    var _reason = ""
    switch (_best_action_enum){
        case ACTIONS.Tidur:
        case ACTIONS.Istirahat:
            if energy < 20 _reason = "stamina sangat rendah"
            else if stress > 70 _reason = "butuh relaksasi"
            else _reason = "memulihkan stamina"
            break
        
        case ACTIONS.Makan:
            if health < 30 _reason = "kesehatan kritis"
            else _reason = "memenuhi kebutuhan nutrisi"
            break
            
        case ACTIONS.Bekerja:
            if money < 10 _reason = "keuangan menipis"
            else _reason = "mencari pemasukan"
            break
            
        case ACTIONS.Liburan:
        case ACTIONS.Bermain:
            if stress > 80 _reason = "stress sangat tinggi"
            else if social < 30 _reason = "butuh hiburan sosial"
            else _reason = "menghilangkan stress"
            break
            
        case ACTIONS.Bersosialisasi:
            if social < 30 _reason = "merasa kesepian"
            else _reason = "meningkatkan hubungan sosial"
            break
            
        case ACTIONS.Rawat_Jalan:
            if is_sick _reason = "sedang sakit!"
            else _reason = "kesehatan sangat kritis"
            break
            
        case ACTIONS.Olahraga:
            _reason = "menjaga kebugaran"
            break
            
        case ACTIONS.Belajar:
            _reason = "meningkatkan IQ"
            break
            
        default:
            _reason = "menjalani hidup"
            break
    }
    
    return {
        name: action_names[_best_action_enum],
        reason: _reason,
        result_struct: _potential_result,
        q_value: _max_q,
        action_enum: _best_action_enum
    }
}
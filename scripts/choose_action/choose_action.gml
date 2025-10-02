function choose_action(_state_key, _valid_actions){
    if array_length(_valid_actions) == 0 return -1
    
    var _q_values = q_table[? _state_key]
    if is_undefined(_q_values){
        _q_values = array_create(ACTIONS._count, 0)
        q_table[? _state_key] = _q_values
    }
    
    if random(1) < epsilon{
        // EKSPLORASI
        var _random_index = irandom(array_length(_valid_actions) - 1)
        return _valid_actions[_random_index]
    }else{
        // EKSPLOITASI
        var _best_action = _valid_actions[0]
        var _max_q = _q_values[_best_action]
        for (var i = 1; i < array_length(_valid_actions); i++){
            var _current_action = _valid_actions[i]
            if _q_values[_current_action] > _max_q{
                _max_q = _q_values[_current_action]
                _best_action = _current_action
            }
        }
        return _best_action
    }
}
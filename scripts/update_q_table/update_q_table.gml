function update_q_table(_state, _action, _reward, _next_state) {
    // Validasi aksi
    if (_action < 0 || _action >= ACTIONS._count) {
        show_debug_message("ERROR: Aksi tidak valid saat update Q-Table: " + string(_action));
        return undefined;
    }

    // Inisialisasi state jika perlu
    if (is_undefined(q_table[? _state])) {
        q_table[? _state] = array_create(ACTIONS._count, 0);
    }
    if (is_undefined(q_table[? _next_state])) {
        q_table[? _next_state] = array_create(ACTIONS._count, 0);
    }

    // Ambil nilai Q lama
    var _old_q_values = q_table[? _state];
    var _old_q_value = _old_q_values[_action];

    // Cari nilai Q terbaik untuk next_state
    var _next_q_values = q_table[? _next_state];
    var _max_next_q = _next_q_values[0];
    for (var i = 1; i < array_length(_next_q_values); i++) {
        if (_next_q_values[i] > _max_next_q) {
            _max_next_q = _next_q_values[i];
        }
    }

    // Hitung nilai target dan nilai Q baru
    var _target_value = _reward + gamma * _max_next_q;
    var _new_q_value = _old_q_value + alpha * (_target_value - _old_q_value);

    // Update Q-table
    q_table[? _state][@ _action] = _new_q_value;

    // Kembalikan detail pembelajaran
    return {
        past_q: _old_q_value,
        present_q: _new_q_value,
        target_q: _target_value
    };
}

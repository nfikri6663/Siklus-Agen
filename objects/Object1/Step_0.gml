if keyboard_check_pressed(vk_space){
    if (game_phase == "manual_play" && !is_simulating) {
        is_simulating = true;
        days_passed++;
        age++
        current_day_log = [];
        alarm[0] = 1
    }
}

if keyboard_check_pressed(vk_right) q_viewer_time_index = (q_viewer_time_index + 1) % 3;
if keyboard_check_pressed(vk_left) q_viewer_time_index = (q_viewer_time_index - 1 + 3) % 3;
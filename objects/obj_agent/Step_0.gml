if keyboard_check_pressed(vk_space) && health > 0{
    if game_phase == "auto_learning"{
        if array_length(current_day_log) == 0{
            alarm[0] = 1
            alarm[3] = room_speed
        }else alarm[1] = 1
    }else
    if !is_simulating{
        is_simulating = true
        days_passed++
        age++
        current_day_log = []
        alarm[0] = 1
    }
}

if keyboard_check_pressed(vk_enter) game_restart()
if game_phase != "auto_learning" && days_passed == 0 current_day_log = []
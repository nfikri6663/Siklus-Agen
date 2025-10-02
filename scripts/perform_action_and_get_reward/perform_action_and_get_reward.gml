function perform_action_and_get_reward(_action, _dry_run = false){
    var _result = {
        reward: 0,
        reason: "Aksi Berhasil",
        delta_iq: 0, delta_money: 0, delta_health: 0, delta_hungry: 0,
        delta_social: 0, delta_stress: 0, delta_energy: 0
    }
    
    // --- Bonus Kebutuhan (Urgency Bonus) ---
    // Bonus ini mendorong AI untuk mengatasi kebutuhannya yang paling mendesak
    var _urgency_health = s_health_cat == "rendah" ? 200 : (s_health_cat == "sedang" ? 50 : 0)
    var _urgency_energy = s_energy_cat == "rendah" ? 50 : (s_energy_cat == "sedang" ? 25 : 0)
    var _urgency_hungry = s_hungry_cat == "SangatLapar" ? 70 : (s_hungry_cat == "lapar" ? 35 : 0)
    var _urgency_stress = stress > 80 ? 50 : (stress > 60 ? 25 : 0)
    var _urgency_money =  s_money_cat == "miskin" ? 200 : (s_money_cat == "cukup" ? 80 : 20)
    var _urgency_social = social < 30 ? 40 : (social < 50 ? 20 : 0)
    var _urgency_iq = stress < 40 && energy > 60 && age >= 6 && age <= 22 ? 20 : 0
    
    // --- Faktor Efektivitas ---
    // Kondisi agen mempengaruhi seberapa baik sebuah aksi dilakukan
    var effectiveness = 1.0
    if stress > 70 effectiveness -= 0.3
    if energy < 30 effectiveness -= 0.4
    effectiveness = max(0.1, effectiveness)
    
    var cost = 0
    switch (_action){
        // =================================================================
        case ACTIONS.Tidur:
            var energy_gain = 25
            if time_of_day == "malam"{
                energy_gain = 50
                _result.reward += 15
            } else if time_of_day == "pagi"{
                if s_age_cat != "bayi"{
                    _result.reward -= 60
                    _result.reason = "Malas, tidur di pagi hari"
                }
            }
            if s_energy_cat == "tinggi"{
                _result.reward -= 50
                _result.reason = "Tidak lelah, buang waktu"
            }
            _result.delta_energy += round(energy_gain * effectiveness)
            _result.delta_stress -= 20
            _result.delta_hungry += 10
            _result.reward += (energy_gain / 2) + _urgency_energy
            break
        // =================================================================
        case ACTIONS.Makan:
            cost = 15
            if money < cost{
                _result.reward = -100
                _result.reason = "Uang tidak cukup untuk makan"
                break
            }
            if s_hungry_cat == "kenyang"{
                _result.reward = -60
                _result.reason = "Makan saat sudah kenyang"
            }
            _result.delta_money -= cost
            _result.delta_hungry -= 50
            _result.delta_energy += 10
            _result.reward += 25 + _urgency_hungry
            break
        // =================================================================
        case ACTIONS.Bekerja:
            if age < 13{
                _result.reward = -200
                _result.reason = "Kerja di bawah umur"
                break
            }
            if age > 65{
                _result.reward = -200
                _result.reason = "Sudah waktunya pensiun"
                break
            }
            var money_gained = round((30 + (iq * 0.5)) * effectiveness)
            _result.delta_money += money_gained
            _result.delta_energy -= 30
            _result.delta_stress += 15
            _result.delta_hungry += 15
            _result.reward += money_gained + _urgency_money
            if effectiveness < 0.5 _result.reason = "Kerja tidak produktif"
            break
        // =================================================================
        case ACTIONS.Belajar:
            if s_age_cat == "bayi"{
                _result.reward = -120
                _result.reason = "Terlalu muda untuk belajar formal"
                break
            }
            cost = 10
            if money < cost{
                _result.reward = -80
                _result.reason = "Uang tidak cukup untuk belajar"
                break
            }
            _result.delta_money -= cost
            _result.delta_iq += round(5 * effectiveness)
            _result.delta_energy -= 15
            _result.delta_stress += 5
            _result.reward += 15 + _urgency_iq
            if effectiveness < 0.5 _result.reason = "Belajar tidak fokus"
            break
        // =================================================================
        case ACTIONS.Bersosialisasi:
            if s_age_cat == "bayi"{
                _result.reward = -120
                _result.reason = "Terlalu muda untuk bersosialisasi kompleks"
                break
            }
            cost = 20
            if money < cost{
                _result.reward = -60
                _result.reason = "Butuh uang untuk jalan-jalan"
                break
            }
            _result.delta_money -= cost
            _result.delta_social += round(15 * effectiveness)
            _result.delta_stress -= 20
            _result.delta_energy -= 10
            _result.reward += 20 + _urgency_social
            break
        // =================================================================
        case ACTIONS.Olahraga:
            if s_age_cat == "bayi"{
                _result.reward = -200
                _result.reason = "Bayi masih mudah lelah untuk olahraga"
                break
            }
            if energy < 30 || health < 30{
                _result.reward = -100
                _result.reason = "Kondisi fisik terlalu lemah untuk olahraga"
                break
            }
            _result.delta_health += 15
            _result.delta_energy -= 35
            _result.delta_stress -= 10
            _result.delta_hungry += 20
            _result.reward += 25 + _urgency_health
            break
        // =================================================================
        case ACTIONS.Liburan:
            if age < 18{
                _result.reward = -120
                _result.reason = "Liburan butuh pendamping"
                break
            }
            cost = 150
            if money < cost{
                _result.reward = -200
                _result.reason = "Uang tidak cukup untuk liburan"
                break
            }
            if stress < 40{
                _result.reward = -80
                _result.reason = "Tidak stres, buang-buang uang"
            }
            _result.delta_money -= cost
            _result.delta_stress -= 60
            _result.delta_social += 10
            _result.reward += 40 + _urgency_stress
            break
        // =================================================================
        case ACTIONS.Menikah:
            if is_married{
                _result.reward = -500
                _result.reason = "Sudah menikah!"
                break
            }
            if age < 22{
                _result.reward = -200
                _result.reason = "Belum cukup dewasa untuk menikah"
                break
            }
            if social < 60{
                _result.reward = -200
                _result.reason = "Hubungan sosial belum matang"
                break
            }
            cost = 500
            if money < cost{
                _result.reward = -300
                _result.reason = "Finansial belum siap untuk menikah"
                break
            }
            _result.delta_money -= cost
            _result.delta_stress -= 30
            _result.reward += 300
            if !_dry_run is_married = true
            break
        // =================================================================
        case ACTIONS.Punya_Anak:
            if !is_married{
                _result.reward = -500
                _result.reason = "Harus menikah terlebih dahulu"
                break
            }
            if age < 25{
                _result.reward = -300
                _result.reason = "Belum siap secara mental/fisik"
                break
            }
            cost = 300
            if money < cost{
                _result.reward = -250
                _result.reason = "Finansial belum siap untuk anak"
                break
            }
            _result.delta_money -= cost
            _result.delta_stress += 30
            _result.delta_energy -= 20
            _result.reward += 200
            break
        // =================================================================
        case ACTIONS.Rawat_Jalan:
            cost = 30
            if money < cost{
                _result.reward = -100
                _result.reason = "Uang tidak cukup untuk berobat"
                break
            }
            if !is_sick && health > 80{
                _result.reward = -60
                _result.reason = "Tidak sakit, buang-buang uang"
            }
            _result.delta_money -= cost
            _result.delta_health += is_sick ? 60 : 10
            _result.reward += 30 + _urgency_health
            break
        // =================================================================
        case ACTIONS.Bermain: // Aksi ringan, untuk anak & dewasa
             if energy < 15{
                _result.reward = -30
                _result.reason = "Terlalu lelah untuk bermain"
                break
            }
            _result.delta_stress -= 15
            _result.delta_social += 5
            _result.delta_energy -= 10
            _result.reward += 15 + (_urgency_stress / 2) + (_urgency_social / 2)
            break
        // =================================================================
        case ACTIONS.Menangis:
            if s_age_cat != "bayi"{
                _result.reward = -80
                _result.reason = "Sudah besar, jangan cengeng"
            }else{
                _result.delta_social += 2
                _result.delta_stress -= 2
                _result.delta_energy -= 5
                _result.reward += max(_urgency_hungry, _urgency_energy, _urgency_health, _urgency_stress)
            }
            break
        // =================================================================
        case ACTIONS.Istirahat:
            _result.delta_energy += 10
            _result.delta_stress -= 5
            _result.reward += 3 + (_urgency_energy / 5)
            break
    }
    
    if !_dry_run{
        iq += _result.delta_iq
        money += _result.delta_money
        health += _result.delta_health
        hungry += _result.delta_hungry
        social += _result.delta_social
        stress += _result.delta_stress
        energy += _result.delta_energy
        
        if hungry > 95 health -= 5
        if energy < 5 health -= 5
        if stress > 95 health -= 5
        if health <= 0 { _result.reward -= 5000 } // Penalti Kematian
        
        health = clamp(health, 0, 100)
        hungry = clamp(hungry, 0, 100)
        energy = clamp(energy, 0, 100)
        stress = clamp(stress, 0, 100)
        social = clamp(social, 0, 100)
        iq = clamp(iq, 0, 200)
        money = max(0, money)
    }
    
    return _result
}
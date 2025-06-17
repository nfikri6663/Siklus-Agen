function perform_action_and_get_reward(_action, _dry_run = false) {
    var _result = {
        reward: -1, 
        reason: "Aksi Berhasil",
        delta_iq: 0, delta_money: 0, delta_health: 0, delta_hungry: 0,
        delta_social: 0, delta_stress: 0, delta_energy: 0
    };

    // --- Bonus Kebutuhan (Urgency Bonus) ---
    // Dihitung di setiap siklus untuk menilai prioritas agen.
    var _urgency_health = (s_health_cat == "rendah") ? 70 : ((s_health_cat == "sedang") ? 35 : 0);
    var _urgency_energy = (s_energy_cat = "rendah") ? 60 : ((s_energy_cat = "sedang") ? 30 : 0);
    var _urgency_hungry = (s_hungry_cat = "SangatLapar") ? 50 : ((s_hungry_cat = "lapar") ? 25 : 0);
    var _urgency_stress = (stress > 80) ? 50 : ((stress > 60) ? 25 : 0);
    var _urgency_money =  (s_money_cat  = "miskin") ? 40 : ((s_money_cat  = "cukup") ? 20 : 0);
    var _urgency_social = (social < 30) ? 30 : ((social < 50) ? 15 : 0);
    // "Urgency" IQ adalah bonus kesempatan, bukan kebutuhan kritis.
    var _urgency_iq = (stress < 40 && energy > 50 && hungry < 50 && age >= 6 && age <= 22) ? 25 : 0;
    
    var effectiveness = 1;
    if (stress > 70) effectiveness -= 0.25;
    if (energy < 30) effectiveness -= 0.25;
    effectiveness = max(0.25, effectiveness);
    
    switch (_action) {
        case ACTIONS.Tidur:
            var energy_gain = (time_of_day == "malam" ? 30 : 15);
            _result.delta_energy += energy_gain;
            _result.delta_health += 5;
            _result.delta_stress -= 15;
            _result.delta_hungry += 10;
            _result.reward += (energy_gain / 2) + _urgency_energy;
            if (energy > 95) {
                _result.reward -= 30;
                _result.reason = "tidak efektif, tidak lelah";
            }
            break;
        case ACTIONS.Makan:
            var cost_of_food = 15;
            if (money >= cost_of_food) {
                _result.delta_money -= cost_of_food;
                _result.delta_hungry -= 50;
                _result.delta_energy += 10;
                _result.reward += 25 + _urgency_hungry;
                if (hungry < 30) {
                     _result.reward -= 50;
                     _result.reason = "kenyang, buang2x uang";
                }
            } else {
                _result.reward -= 200;
                _result.reason = "uang tidak cukup"; // REVISI: Memberikan alasan kegagalan
            }
            break;
        case ACTIONS.Bekerja:
            var money_gained = round(25 * effectiveness);
            _result.delta_money += money_gained;
            _result.delta_energy -= 20;
            _result.delta_stress += 5;
            _result.delta_hungry += 15;
            _result.reward += money_gained + _urgency_money;
            if (effectiveness < 0.5) {
                _result.reward -= 20;
                _result.reason = "tidak efektif, kondisi buruk";
            }
            break;
        case ACTIONS.Belajar:
            var cost_of_learning = 5;
            if (money >= cost_of_learning) {
                _result.delta_money -= cost_of_learning;
                _result.delta_iq += round(3 * effectiveness);
                _result.delta_energy -= 15;
                _result.delta_stress += 5;
                _result.reward += 10 + _urgency_iq;
                if (effectiveness < 0.5) {
                    _result.reward -= 30;
                    _result.reason = "tidak fokus, kondisi buruk";
                }
            } else {
                 _result.reward -= 50;
                 _result.reason = "uang tidak cukup"; // REVISI: Memberikan alasan kegagalan
            }
            break;
        case ACTIONS.Bersosialisasi:
            var cost_of_social = 10;
            if (money >= cost_of_social) {
                _result.delta_money -= cost_of_social;
                _result.delta_social += round(10 * effectiveness);
                _result.delta_stress -= 10;
                _result.delta_energy -= 10;
                _result.reward += 15 + _urgency_social + (_urgency_stress / 2);
            } else {
                _result.reward -= 70;
                _result.reason = "uang tidak cukup"; // REVISI: Memberikan alasan kegagalan
            }
            break;
        case ACTIONS.Olahraga:
            if (energy >= 30 && health >= 30) {
                _result.delta_health += 10;
                _result.delta_stress -= 5;
                _result.delta_energy -= 25;
                _result.delta_hungry += 20;
                _result.reward += 15 + _urgency_health;
            } else {
                _result.reward -= 60;
                _result.reason = "kondisi fisik terlalu lemah"; // REVISI: Memberikan alasan kegagalan
            }
            break;
        case ACTIONS.Liburan:
            var cost_of_holiday = 80;
            if (money >= cost_of_holiday) {
                if (stress > 50) {
                    _result.delta_money -= cost_of_holiday;
                    _result.delta_stress -= 40;
                    _result.delta_social += 10;
                    _result.reward += 30 + (_urgency_stress * 1.5);
                } else {
                    _result.reward -= 100;
                    _result.reason = "tidak stres, buang2x uang"; // REVISI: Memberikan alasan spesifik
                }
            } else {
                _result.reward -= 100;
                _result.reason = "uang tidak cukup"; // REVISI: Memberikan alasan spesifik
            }
            break;
        case ACTIONS.Menikah:
            var cost_of_marriage = 250;
            if (money > cost_of_marriage && social > 60 && age >= 22) {
                _result.delta_money -= cost_of_marriage;
                _result.delta_social += 20;
                _result.delta_stress -= 10;
                _result.reward += 150;
            } else {
                _result.reward -= 300;
                // REVISI: Memberikan alasan kegagalan yang paling relevan
                if (money <= cost_of_marriage) _result.reason = "finansial belum siap";
                else if (social <= 60) _result.reason = "hubungan sosial belum cukup";
                else _result.reason = "belum cukup umur";
            }
            break;
        case ACTIONS.Punya_Anak:
            var cost_of_child = 100;
            // Asumsi: harus sudah menikah (tambahkan variabel is_married jika perlu)
            if (money > cost_of_child && age >= 24) {
                 _result.delta_money -= cost_of_child;
                 _result.delta_stress += 20; // Punya anak menambah stres
                 _result.delta_energy -= 15;
                 _result.reward += 100; // Imbalan pencapaian hidup, tapi lebih rendah dari menikah
            } else {
                _reason = "uang tidak cukup";
                _result.reward -= 250; // Penalti besar jika tidak siap
            }
            break;
        case ACTIONS.Rawat_Jalan:
            var cost_of_treatment = 40;
            if (money >= cost_of_treatment) {
                _result.delta_money -= cost_of_treatment;
                _result.delta_health += 30;
                _result.reward += round(20 + _urgency_health); // Sangat penting jika kesehatan kritis
            } else {
                _reason = "uang tidak cukup";
                _result.reward -= 150; // Penalti jika sakit tapi tak bisa berobat
            }
            if (!is_sick && health > 70) _result.reward -= 60;
            break;
        case ACTIONS.Bermain:
             _result.delta_stress -= 15;
             _result.delta_social += 5;
             _result.delta_energy -= 10;
             _result.reward += round(15 + (_urgency_stress / 2) + (_urgency_social / 2));
             if (energy < 20 || hungry > 80) _result.reward -= 30;
             break;
        case ACTIONS.Menangis: // Hanya untuk bayi
            if (age <= 5) {
                // Menangis adalah cara bayi mengkomunikasikan kebutuhan paling mendesak
                var max_urgency = max(_urgency_hungry, _urgency_energy, _urgency_health);
                _result.reward += round(max_urgency);
                _result.delta_energy -= 5;
                _result.delta_social += 2;
            } else {
                _reason = "sudah gede, jangan nagis";
                _result.reward -= 50; // Penalti jika sudah bukan bayi tapi masih menangis
            }
            break;
        case ACTIONS.Sakit:
            // Ini adalah state, bukan aksi. Seharusnya tidak pernah dipilih.
            // Jika terpilih, itu bug di get_valid_actions. Beri penalti agar tidak diulangi.
            _result.reward -= 500;
            break;
        default:
             _result.reason = "aksi tidak diimplementasikan dengan `reason`";
             break;
    }
    if (!_dry_run) {
        iq += _result.delta_iq; money += _result.delta_money; health += _result.delta_health;
        hungry += _result.delta_hungry; social += _result.delta_social; stress += _result.delta_stress;
        energy += _result.delta_energy;
        
        if (hungry > 95) { health -= 3; _result.reward -= 15; }
        if (energy < 5) { health -= 2; _result.reward -= 15; }
        if (stress > 95) { health -= 2; _result.reward -= 15; }
        if (health <= 0) { _result.reward -= 1000; } // Penalti besar untuk kematian
        
        health = clamp(health, 0, 100); hungry = clamp(hungry, 0, 100); energy = clamp(energy, 0, 100);
        stress = clamp(stress, 0, 100); social = clamp(social, 0, 100); iq = clamp(iq, 0, 200); money = max(0, money);
    }
    return _result;
}
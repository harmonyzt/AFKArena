#include < amxmodx >
#include < fun >
#include < cstrike >
#include < hamsandwich >
#include < amxmisc >
#include < cs_teams_api >

new sync_hud_count

new countdown = 0;

new exp[32], exp_next_lvl[32], level[32];
new money[32];

public plugin_init()
{
	register_plugin("AFK Arena", "1.0", "harmony");
    register_logevent("round_start", 2, "1=Round_Start");
	register_event("SendAudio", "mutants_win", "a", "2&%!MRAD_terwin");
	register_event("SendAudio", "heroes_win", "a", "2&%!MRAD_ctwin");
	register_dictionary("afk_arena.txt");
	RegisterHam(Ham_Killed, "player", "player_killed", 1);
	RegisterHam(Ham_Spawn, "player", "player_spawn", 1);
	RegisterHam(Ham_TakeDamage,"player","player_damaged");
	sync_hud_count = CreateHudSyncObj();
    set_task(1.0,"display_hud",_,_,_,"b");
}

public mutants_win(){
}

public heroes_win(){
}

public player_spawn(){
}

public player_killed(victim,killer){
	if(victim != killer) {
		exp[killer] += level[killer] + 15; 
	}
}

public client_putinserver(id){
	exp[id] = 0;
	exp_next_lvl[id] = 300;
	level[id] = 1;
}

public display_hud(){
	if(countdown >= 1){
		countdown--
	}
	if(countdown < 11 && countdown > 0){
		client_print(0,print_chat,"%L", LANG_PLAYER, "INFECTION_BEGINS_IN", countdown)
	} else {
		// Begin infection
	}

	for(new id = 1; id <= get_maxplayers(); id++){
		if(!is_user_bot(id) && is_user_connected(id) && is_user_alive(id))
		{
			set_hudmessage(150, 100, 100,-1.0,0.85, 0, 1.0, 1.0);
			show_hudmessage(id,"%L",LANG_PLAYER,"HUD_EXP", exp[id], exp_next_lvl[id], level[id], money[id]);
		}
	}
}

public player_damaged(victim,inflictor,attacker,Float:damage,damagebits){
		if(!attacker || attacker > get_maxplayers())
			return HAM_IGNORED;
	
		if(0 < inflictor <= get_maxplayers()){
			exp[attacker] += 3;

			// Check EXP
			check_exp(attacker);
		}
	return HAM_IGNORED
}

public check_exp(id){
	if(exp[id] >= exp_next_lvl[id]){
		level[id]++
		money[id] += level[id] + 5;
		exp_next_lvl[id] += 650;
		client_cmd(id,"spk afkarena/lvlup");
	}
}

// Infection Begins
public round_start(){
	client_print(0,print_chat,"%L", LANG_PLAYER, "INFECTION_STARTS_SOON");
	countdown = 15;
}

public plugin_precache(){
	precache_sound("afkarena/lvlup.wav");
}
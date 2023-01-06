#include < amxmodx >
#include < fun >
#include < cstrike >
#include < hamsandwich >
#include < amxmisc >
#include < cs_teams_api >

new exp[32], exp_next_lvl[32], level[32];
new money[32];

public plugin_init()
{
    register_logevent("round_start", 2, "1=Round_Start");
	register_event("SendAudio", "mutants_win", "a", "2&%!MRAD_terwin");
	register_event("SendAudio", "heroes_win", "a", "2&%!MRAD_ctwin");
	register_library("afk_arena");
	RegisterHam(Ham_Killed, "player", "player_killed", 1);
	RegisterHam(Ham_Spawn, "player", "player_spawn", 1);
	RegisterHam(Ham_TakeDamage,"player","player_damaged");
    set_task(1.0,"display_hud",_,_,_,"b");
}

public mutants_win(){
}
public heroes_win(){
}
public player_spawn(){
}
public player_killed(){
}

public client_putinserver(id){
	exp[id] = 0;
	exp_next_lvl[id] = 300;
	level[id] = 1;
}

public display_hud(){
	for(new id = 1; id <= get_maxplayers(); id++){
		if(!is_user_bot(id) && is_user_connected(id) && is_user_alive(id))
		{
			set_hudmessage(100, 100, 100,-1.0,0.90, 0, 1.0, 1.0);
			show_hudmessage(id,"%L",LANG_PLAYER,"HUD_EXP", exp[id], exp_next_lvl[id]);
		}
	}
}

public player_damaged(victim,inflictor,attacker,Float:damage,damagebits){
		if(!attacker || attacker > get_maxplayers())
			return HAM_IGNORED;
	
		if(0 < inflictor <= get_maxplayers()){
			exp[attacker] += 3;

			// Level Up
			if(exp[attacker] >= exp_next_lvl[attacker]){
				exp_next_lvl[attacker] += 650;
				level[attacker] += 1;
				money[attacker] += level[attacker] + 5;
			}
		}
	return HAM_IGNORED
}

// Inf Begins
public round_start(){

}

public plugin_precache(){

}
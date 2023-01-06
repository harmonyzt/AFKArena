#include < amxmodx >
#include < fun >
#include < cstrike >
#include < hamsandwich >
#include < amxmisc >
#include < cs_teams_api >

public plugin_init()
{
    register_logevent( "round_start", 2, "1=Round_Start" )
	register_event("SendAudio", "mutants_win", "a", "2&%!MRAD_terwin")
	register_event("SendAudio", "heroes_win", "a", "2&%!MRAD_ctwin")
	RegisterHam(Ham_Killed, "player", "player_killed", 1)
	RegisterHam(Ham_Spawn, "player", "player_spawn", 1)
    set_task(1.0, "display_hud",_,_,_, "b")
}

public plugin_cfg()
{
	new szCfgDir[64], szFile[192];
	get_configsdir(szCfgDir, charsmax(szCfgDir));
	formatex(szFile,charsmax(szFile),"%s/afk_arena/afk_arena.cfg",szCfgDir);
	if(file_exists(szFile))
		server_cmd("exec %s", szFile);
}


public plugin_precache(){

}
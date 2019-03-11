#include <sourcemod>
#include <tf2_stocks>

TFClassType
	g_warClass;
	
public Plugin myinfo = 
{
	name = "Class Warfare: Arena",
	author = "myst",
	description = "Class Warfare made for Arena gamemodes, built for Deathrun, Vs Saxton Hale and Freak Fortress",
	version = "1.0",
	url = "https://titan.tf"
}

public void OnPluginStart()
{
	HookEvent("teamplay_round_start", Event_RoundStart);
	HookEvent("arena_round_start", Event_RoundActuallyStart);
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Action Event_RoundStart(Handle hEvent, const char[] sEventName, bool bDontBroadcast) 
{
	g_warClass = view_as<TFClassType>(GetRandomInt(1, 9));
}

public Action Event_RoundActuallyStart(Handle hEvent, const char[] sEventName, bool bDontBroadcast) 
{
	for (int iClient = 1; iClient <= MaxClients; iClient++) 
	{
		if (IsValidClient(iClient))
		{
			if (TF2_GetClientTeam(iClient) == TFTeam_Red)
			{
				Client_PrintModMessage(iClient);
				Client_VerifySelection(iClient);
			}
		}
	}
}

public Action Event_PlayerSpawn(Handle hEvent, const char[] sEventName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	Client_VerifySelection(iClient);
}

void Client_PrintModMessage(int iClient)
{
	if (IsValidClient(iClient))
	{
		char sClass[20];
		
		switch (g_warClass)
		{
			case TFClass_Scout: 		sClass = "Scout";
			case TFClass_Soldier:		sClass = "Soldier";
			case TFClass_Pyro:			sClass = "Pyro";
			case TFClass_DemoMan:		sClass = "Demoman";
			case TFClass_Heavy:			sClass = "Heavy";
			case TFClass_Engineer:		sClass = "Engineer";
			case TFClass_Medic:			sClass = "Medic";
			case TFClass_Sniper:		sClass = "Sniper";
			case TFClass_Spy:			sClass = "Spy";
			default:					sClass = "Unknown";
		}
		
		PrintCenterText(iClient, "This is Class Warfare. It is %s this round.", sClass);
	}
}

void Client_VerifySelection(int iClient)
{
	if (IsValidClient(iClient))
	{
		if (GetClientTeam(iClient) == view_as<int>(TFTeam_Red))
		{
			TFClassType clientClass = TF2_GetPlayerClass(iClient);
			
			if (clientClass != g_warClass)
			{
				TF2_SetPlayerClass(iClient, g_warClass);
				TF2_RespawnPlayer(iClient);
				Client_PrintModMessage(iClient);
			}
		}
	}
}

stock bool IsValidClient(int iClient, bool bReplay = true)
{
	if (iClient <= 0 || iClient > MaxClients || !IsClientInGame(iClient))
		return false;
	if (bReplay && (IsClientSourceTV(iClient) || IsClientReplay(iClient)))
		return false;
	return true;
}
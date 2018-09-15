#include <tf2_stocks>

int g_iClass;

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
	g_iClass = GetRandomInt(1, 9);
}

public Action Event_RoundActuallyStart(Handle hEvent, const char[] sEventName, bool bDontBroadcast) 
{
	for (int iClient = 1; iClient <= MaxClients; iClient++) 
	{
		if (IsValidClient(iClient))
		{
			if (GetClientTeam(iClient) == view_as<int>(TFTeam_Red))
			{
				if (IsClientInGame(iClient)) PrintModMessage(iClient);
				VerifySelection(iClient);
			}
		}
	}
}

public Action Event_PlayerSpawn(Handle hEvent, const char[] sEventName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	VerifySelection(iClient);
}

void PrintModMessage(int iClient)
{
	if (IsValidClient(iClient))
	{
		char sClass[20];
		
		switch (g_iClass)
		{
			case 1: 	sClass = "Scout";
			case 2:		sClass = "Soldier";
			case 3:		sClass = "Pyro";
			case 4:		sClass = "Demoman";
			case 5:		sClass = "Heavy";
			case 6:		sClass = "Engineer";
			case 7:		sClass = "Medic";
			case 8:		sClass = "Sniper";
			case 9:		sClass = "Spy";
			default:	sClass = "Scout";
		}
		
		PrintCenterText(iClient, "This is Class Warfare. It is %s this round.", sClass);
	}
}

void VerifySelection(int client)
{
	if (IsValidClient(client))
	{
		if (GetClientTeam(client) == view_as<int>(TFTeam_Red))
		{
			int iClass;
			TFClassType TFClass = TF2_GetPlayerClass(client);
			
			switch (TFClass)
			{
				case TFClass_Scout:  	iClass = 1;
				case TFClass_Soldier:	iClass = 2;
				case TFClass_Pyro:		iClass = 3;
				case TFClass_DemoMan:	iClass = 4;
				case TFClass_Heavy:		iClass = 5;
				case TFClass_Engineer:	iClass = 6;
				case TFClass_Medic:		iClass = 7;
				case TFClass_Sniper:	iClass = 8;
				case TFClass_Spy:		iClass = 9;
			}
			
			if (iClass != g_iClass)
			{
				switch (g_iClass)
				{
					case 1: 	TF2_SetPlayerClass(client, TFClass_Scout);
					case 2: 	TF2_SetPlayerClass(client, TFClass_Soldier);
					case 3: 	TF2_SetPlayerClass(client, TFClass_Pyro);
					case 4: 	TF2_SetPlayerClass(client, TFClass_DemoMan);
					case 5: 	TF2_SetPlayerClass(client, TFClass_Heavy);
					case 6: 	TF2_SetPlayerClass(client, TFClass_Engineer);
					case 7: 	TF2_SetPlayerClass(client, TFClass_Medic);
					case 8: 	TF2_SetPlayerClass(client, TFClass_Sniper);
					case 9: 	TF2_SetPlayerClass(client, TFClass_Spy);
					default: 	TF2_SetPlayerClass(client, TFClass_Scout);
				}
				
				TF2_RespawnPlayer(client);
				PrintModMessage(client);
			}
		}
	}
}

stock bool IsValidClient(int client, bool bReplay = true)
{
	if (client <= 0 || client > MaxClients || !IsClientInGame(client))
		return false;
	if (bReplay && (IsClientSourceTV(client) || IsClientReplay(client)))
		return false;
	return true;
}
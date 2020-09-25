#include <a_samp>
#include <zcmd>
#include <sscanf>
#define DIALOG_INVENTORY 1054
#define MAX_SLOT 9
#define MAX_ITEM 3

new SlotInventory[MAX_PLAYERS][MAX_SLOT];
new AmmountItem[MAX_PLAYERS][MAX_ITEM];
CMD:additem(playerid, params[]) {
	new giveplayerid,itemid,soluong;
	if(sscanf(params, "udd", giveplayerid,itemid,soluong)) return SendClientMessage(playerid, -1, "Su dung:/additem [playerid] [itemid] [soluong]");
	if(itemid < 0 || itemid >  MAX_ITEM) return SendClientMessage(playerid, -1, "Da co loi.");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, -1, "Nguoi choi khong hop le.");
	for(new i = 0 ; i < MAX_SLOT ; i++) {
		if(SlotInventory[playerid][i] == itemid) {
			AmmountItem[playerid][itemid] += soluong;
			print("+amount" );
			return 1;
		}
	    else if(SlotInventory[playerid][i] == 0) {
	    	SlotInventory[playerid][i] = itemid;
	    	AmmountItem[playerid][itemid] = soluong;
	    	print("add item new" );
	    	return 1;
	    }
	}
	return 1;
}
CMD:inv(playerid, params[]) {
	new slot[129];
	for(new i = 0;i< MAX_SLOT ; i++) {
		if(SlotInventory[playerid][i] != 0)
		{
			format(slot, sizeof(slot), "%s\n%s\t%d/100", slot,GetItemName(SlotInventory[playerid][i]),AmmountItem[playerid][SlotInventory[playerid][i]]);
		}
	    else strcat(slot, "\nCon Trong");
	    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "Tui do", slot, "Su dung", "Vut bo");
	}
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if(dialogid == DIALOG_INVENTORY) {
		if(response) {
			if(listitem < 9) {
				if(SlotInventory[playerid][listitem] != 0) {
						OnPlayerUseItem(playerid, SlotInventory[playerid][listitem] , listitem);
				}
				else {
					SendClientMessage(playerid, -1, "[INVENTORY-BUG] Slot khong co gi.");
				}
			}
		}
	}
	return 1;
}
stock OnPlayerUseItem(playerid, itemid , slot) {
	switch(itemid) {
		case 1: GivePlayerWeapon(playerid, 24, 100);
		case 2: GivePlayerWeapon(playerid, 25, 100);
	}
	if(AmmountItem[playerid][itemid] > 1) {
		AmmountItem[playerid][itemid] -= 1;
		return 1;
	}
	else if(AmmountItem[playerid][itemid] <= 1) {
		AmmountItem[playerid][itemid] = 0;
		SlotInventory[playerid][slot] = 0;
	}
	return 1;
}
stock GetItemName(itemid) {
	new itemname[52];
	switch(itemid) {
		case 0: itemname = "Con trong";
		case 1: itemname = "Deagle";
		case 2: itemname = "Shotgun";
	}
	return itemname;
}
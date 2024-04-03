local commandHelp = [[ 
/help - shows this command list.
@ <text> - sends a private message to admin(s).

<ADMIN-ONLY> CONSOLE COMMANDS:
clearallgrounditems - clears all ground items in the map with an active physics body.
forceclearduffelbags - forces the game to remove all duffel bags and their contents.
]]
function messageClient (client, msgType, text, sender)
	if CLIENT then return end
	-- Ignore means don't say anything
	if msgType == 'ignore' then
		return
	-- For other stuff
	elseif msgType == 'text-general' then
		local chatMessage = ChatMessage.Create('[General Info]', text, ChatMessageType.Server, nil, nil)
		chatMessage.Color = Color(180, 180, 200, 255)
		Game.SendDirectChatMessage(chatMessage, client)
	
	-- Warnings/Errors
	elseif msgType == 'text-warning' then
		local chatMessage = ChatMessage.Create('[Warning]', text, ChatMessageType.Server, nil, nil)
		chatMessage.Color = Color(255, 75, 75, 255)
		Game.SendDirectChatMessage(chatMessage, client)
	-- Generic Info
	elseif msgType == 'text-info' then
		local chatMessage = ChatMessage.Create('[Info]', text, ChatMessageType.Server, nil, nil)
		chatMessage.Color = Color(250, 125, 75, 255)
		Game.SendDirectChatMessage(chatMessage, client)
	-- Chat Commands
	elseif msgType == 'text-command' then
		local chatMessage = ChatMessage.Create('[Chat Command]', text, ChatMessageType.Server, nil, nil)
		chatMessage.Color = Color(190, 215, 255, 255)
		Game.SendDirectChatMessage(chatMessage, client)
	-- AdminPMs
	elseif msgType == 'admin-pm' then
		local chatMessage = ChatMessage.Create('[AdminPM]', text, ChatMessageType.Server, nil, nil)
		chatMessage.Color = Color(255, 100, 100, 255)
		Game.SendDirectChatMessage(chatMessage, client)
	-- Regular chat
	elseif msgType == 'chat-regular' then
		local chatMessage = ChatMessage.Create(sender, text, ChatMessageType.Default, nil, nil)
		Game.SendDirectChatMessage(chatMessage, client)
	-- Big popup
	elseif msgType == 'popup' then
		Game.SendDirectChatMessage(msgType,text, nil, ChatMessageType.MessageBox, client)
		-- Also message user (like with text-general msgType)
		messageClient(client, 'text-general', text)
	-- Subtle popup
	elseif msgType == 'info' then
		Game.SendDirectChatMessage(msgType,text, nil, ChatMessageType.ServerMessageBoxInGame, client, 'WorkshopMenu.InfoButton')
		-- Also message user (like with text-general msgType)
		messageClient(client, 'text-general', text)
	end
end

-- Messages a message to some clients using messageClient
function messageClients (clients, msgType, text, sender)
	for client in clients do
		messageClient(client, msgType, text, sender)
	end
end

-- Messages all clients using messageClients
-- dis shit dont work VVVV
function messageAllClients (msgType, text, sender)
	messageClients(Client.ClientList, msgType, text, sender)
end

-- game commands

Game.AddCommand("clearallgrounditems","clears all ground items in the map with an active physics body", function()
	local numItemsRemoved = 0
    for _, theItem in pairs(Item.ItemList) do
      if not theItem.isContained and theItem.PhysicsBodyActive then
        Entity.Spawner.AddItemToRemoveQueue(theItem)
        numItemsRemoved = numItemsRemoved + 1
      end
    end
    Game.Log("Forcefully Cleared " .. numItemsRemoved .. " Ground Items", ServerLogMessageType.Chat)
    Game.SendMessage("Forcefully Removed " .. numItemsRemoved .. " Ground Items", 0)
end)

Game.AddCommand("forceclearduffelbags", "forces the game to remove all duffel bags and their contents", function ()
	local numBagsRemoved = 0
    for _, theItem in pairs(Item.ItemList) do
        if (theItem.Prefab.Identifier == ('duffelbag')) then
            Entity.Spawner.AddItemToRemoveQueue(theItem)
            numBagsRemoved = numBagsRemoved + 1
        end
    end
    Game.Log("Forcefully Cleared " .. numBagsRemoved .. " Duffel Bags", ServerLogMessageType.Chat)
    Game.SendMessage("Forcefully Cleared " .. numBagsRemoved .. " Duffel Bags", 0)
end)
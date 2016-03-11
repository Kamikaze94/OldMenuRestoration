if not _G.MainRestore then
	_G.MainRestore = {}
	MainRestore.mod_path = ModPath
end

if string.lower(RequiredScript) == "lib/managers/menumanager" then
Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupOldMainMenu", function( menu_manager, nodes )
	if nodes.main then
		local menu = nodes.main
		menu._items = {}
		local file = io.open(MainRestore.mod_path .. "start_menu_full.json", "r")
		if file then
			local menu_items = json.decode(file:read("*all"))
			for k, v in pairs(menu_items) do
				local new_item = menu:create_item( { type = v.type or "CoreMenuItem.Item" } , v )
				new_item._priority = (#menu_items - k) or 1
				menu:add_item(new_item)
			end
			file:close()
		end
		table.sort( menu._items, function(a, b)
			return a._priority > b._priority
		end)
	end
end)
elseif string.lower(RequiredScript) == "lib/managers/menu/mainmenugui" then
	
	local MainMenuGui_update_original = MainMenuGui.update
	function MainMenuGui:update(...)
		MainMenuGui_update_original(self, ...)
		if alive(self._panel) then
			self._panel:set_visible(false)
		end
	end
end
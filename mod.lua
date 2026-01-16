local pink_color = Color(255, 255, 105, 180) / 255

local function ApplyPinkMod()
    if tweak_data and tweak_data.screen_colors then
        for k, v in pairs(tweak_data.screen_colors) do
            tweak_data.screen_colors[k] = pink_color
        end
    end
   
    if not managers or not managers.gui_data then return end

    local ws = managers.gui_data:create_saferect_workspace()
    local panel = ws:panel()
    local text_obj = panel:text({text = "temp"})

    local text_meta = getmetatable(text_obj)
    local panel_meta = getmetatable(panel)

    if panel_meta and panel_meta.text then
        local old_panel_text = panel_meta.text
        panel_meta.text = function(self, config)
            config = config or {}
            config.color = pink_color 
            return old_panel_text(self, config)
        end
    end

    if text_meta and text_meta.set_color then
        local old_set_color = text_meta.set_color
        text_meta.set_color = function(self, color)
            local final_color = pink_color
            if color and color.alpha then
                final_color = final_color:with_alpha(color.alpha)
            end
            return old_set_color(self, final_color)
        end
        
        if text_meta.set_text then
            local old_set_text = text_meta.set_text
            text_meta.set_text = function(self, text)
                 old_set_color(self, pink_color) 
                 return old_set_text(self, text)
            end
        end
    end

    managers.gui_data:destroy_workspace(ws)
    
end

Hooks:Add("MenuManagerInitialize", "PinkText_Init_Hook", ApplyPinkMod)

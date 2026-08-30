-- Theme --
local M = {}
function M.setup()
	vim.opt.termguicolors = true

	local colors = {
		magenta="#300924",
		dark_black="#05080A",
		light_black="#555753",
		dark_red="#CC0000",
		light_red="#EF2929",
		dark_green="#4E9A06",
		light_green="#8AE234",
		dark_yellow="#C4A000",
		light_yellow="#FCE94F",
		dark_blue="#3465A4",
		light_blue="#729FCF",
		dark_purple="#75507B",
		light_purple="#AD7FA8",
		dark_cyan="#06989A",
		light_cyan="#34E2E2",
		dark_white="#D3D7CF",
		light_white="#FFFFFF",
	}
	local highlight = {
		OilDir = { fg=colors.light_white },
		OilDirIcon = { fg=colors.light_white },

		Normal = { fg=colors.light_white, bg=colors.dark_black },
		LineNr = { fg=colors.light_black},
		Cursor = { fg=colors.black, bg=colors.light_white },
		CursorInsert = { fg=colors.black, bg=colors.dark_green },
		CursorReplace = { fg=colors.black, bg=colors.dark_green },
		ModeMsg = { fg=colors.dark_green, bold=true },
		Identifier = { fg=colors.light_white },
		Delimiter = { fg=colors.light_white },

		Comment = { fg=colors.dark_white, italic=true },
		Constant = { fg=colors.light_cyan },
		cConstant = { fg=colors.dark_cyan },
		String = { fg=colors.light_red },

		Keyword = { fg=colors.light_green, bold=true },
		Statement = { fg=colors.light_green, bold=true },
		Type = { fg=colors.dark_green, italic=true },
		PreProc = { fg=colors.dark_cyan },
		Operator = { fg=colors.light_white },
		Function = { fg=colors.light_cyan },

		cParen = { fg=colors.light_white },
		cBracket = { fg=colors.light_white },

		Error = { fg=colors.light_white, bg=colors.light_red, bold=true },
		Special = { fg=colors.dark_yellow },
		Todo = { fg=colors.dark_blue, bg=colors.light_yellow },
		Title = { fg=colors.light_green },

		Visual = { fg=colors.dark_black, bg=colors.dark_green },
		MatchParen = { fg=colors.dark_black, bg=colors.dark_green },
		NonText = { fg=colors.light_black, bold=true },
		CurSearch = { fg=colors.dark_black, bg=colors.light_yellow },

		WarningMsg = { fg=colors.light_red, bold=true },
		ErrorMsg = { fg=colors.light_white, bg=colors.light_red, bold=true },
		MoreMsg = { fg=colors.light_green },
		Question = { fg=colors.light_green },

		TabLine = { fg=colors.light_white, bg=colors.light_black },
		TabLineSel = { fg=colors.light_white, bg=colors.dark_green },
		TabLineFill = { bg=colors.dark_black },
		Pmenu = { fg=colors.dark_black, bg=colors.light_white },
		PmenuSel = { fg=colors._dark_black, bg=colors.light_green },

		Statusline = { fg=colors.black, bg=colors.dark_green },
		StatuslineNC = { fg=colors.dark_black, bg=colors.dark_light },

		-- Tree-sitter
		["@variable"] = { fg=colors.light_white },
	}

	for group, opts in pairs(highlight) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

M.setup()

return M

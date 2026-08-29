-- Theme --
local M = {}
function M.setup()
	vim.opt.termguicolors = true

	local colors = {
		white = "#FFFFFF",
		black = "#000000",
		gray = "#DFDFDF",
		red = "#FF0000",
		green = "#00FF00",
		blue = "#0000FF",
		yellow = "#FFFF00",
		pink = "#FF00FF",
		purple = "#6A0DAD",
		lavender = "#6A5ACD",
		maroon = "#A52A2A",
		teal = "#2E8B57",
		cyan = "#00FFFF",
		navy = "#000080",
		lemon = "#FFFF99",
		lochinvar = "#2e8b7c",
	}
	local highlight = {
		OilDir = { fg=colors.white },
		OilDirIcon = { fg=colors.white },

		Normal = { fg=colors.white, bg=colors.navy },
		LineNr = { fg=colors.lemon},
		Cursor = { fg=colors.black, bg=colors.lemon },
		CursorInsert = { fg=colors.black, bg=colors.lemon },
		CursorReplace = { fg=colors.black, bg=colors.lemon },
		ModeMsg = { fg=colors.cyan, bold=true },
		Identifier = { fg=colors.cyan },
		Delimiter = { fg=colors.lemon },

		Comment = { fg=colors.lochinvar, italic=true },
		Constant = { fg=colors.green },
		String = { fg=colors.lemon },

		Keyword = { fg=colors.red, bold=true },
		Statement = { fg=colors.red, bold=true },
		Type = { fg=colors.white, italic=true },
		PreProc = { fg=colors.green },
		Operator = { fg=colors.lemon },
		Function = { fg=colors.cyan },

		Error = { fg=colors.white, bg=colors.red, bold=true },
		Special = { fg=colors.lemon },
		Todo = { fg=colors.blue, bg=colors.yellow },
		Title = { fg=colors.lochinvar },

		Visual = { fg=colors.black, bg=colors.lochinvar },
		MatchParen = { bg=colors.black },
		NonText = { fg=colors.gray, bold=true },
		CurSearch = { fg=colors.black, bg=colors.yellow },

		WarningMsg = { fg=colors.red, bold=true },
		ErrorMsg = { fg=colors.white, bg=colors.red, bold=true },
		MoreMsg = { fg=colors.lochinvar },
		Question = { fg=colors.lochinvar },

		TabLine = { fg=colors.gray, bg=colors.navy },
		TabLineSel = { fg=colors.black, bg=colors.lochinvar },
		TabLineFill = { bg=colors.black },
		Pmenu = { fg=colors.black, bg=colors.gray },
		PmenuSel = { fg=colors.black, bg=colors.lochinvar },


		-- Tree-sitter
		["@variable"] = { fg=colors.white },
	}

	for group, opts in pairs(highlight) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

M.setup()

return M

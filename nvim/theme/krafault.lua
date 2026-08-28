-- Theme: krafault --
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
	}
	local highlight = {
		OilDir = { fg=colors.blue },
		OilDirIcon = { fg=colors.blue },

		Normal = { fg=colors.black, bg=colors.white },
		LineNr = { fg=colors.maroon},
		Cursor = { fg=colors.cyan, bg=colors.black },
		ModeMsg = { fg=colors.black, bold=true },
		Identifier = { fg=colors.black },

		Comment = { fg=colors.blue, italic=true },
		Constant = { fg=colors.pink },
		String = { fg=colors.pink },

		Keyword = { fg=colors.maroon, bold=true },
		Statement = { fg=colors.maroon, bold=true},
		Type = { fg=colors.teal, bold=true },
		PreProc = { fg=colors.purple },

		Error = { fg=colors.white, bg=colors.red, bold=true },
		Special = { fg=colors.lavender },
		Todo = { fg=colors.blue, bg=colors.yellow },
		Title = { fg=colors.pink },

		Visual = { bg=colors.gray },
		MatchParen = { bg=colors.cyan },
		NonText = { fg=colors.blue, bold=true },
		CurSearch = { fg=colors.black, bg=colors.yellow },

		WarningMsg = { fg=colors.red, bold=true },
		ErrorMsg = { fg=colors.bg, bg=colors.red, bold=true },
		MoreMsg = { fg=colors.teal },
		Question = { fg=colors.teal },

		TabLine = { fg=colors.white, bg=colors.gray },
		TabLineSel = { fg=colors.black, bg=colors.white },
		TabLineFill = { bg=colors.gray },


		-- Tree-sitter
		["@variable"] = { fg=colors.black },
	}

	for group, opts in pairs(highlight) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

M.setup()

return M

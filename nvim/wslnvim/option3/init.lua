-- PLUGIN MANAGER --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)



require("lazy").setup({
	
	-- Tree-sitter
	{
  	    "nvim-treesitter/nvim-treesitter",
	    branch = "master",
  	    build = ":TSUpdate",
  	    lazy = false,
	},

}, { checker = { enabled = false } })





-- Editor settings --
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.title = true
vim.opt.wrap = false
vim.opt.encoding = 'utf-8'
vim.opt.termguicolors = true

vim.opt.foldcolumn = "1"
vim.opt.fillchars:append({
  eob = ' ',
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.scrolloff = 8



-- Tab engine
local tab_config = {
  text = 2,
  python = 4,
  cpp = 2,
  javascript = 2,
  typescript = 2,
  html = 2,
  lua = 2,
  rust = 4,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(tab_config),
  callback = function(args)
    local size = tab_config[vim.bo[args.buf].filetype]

    vim.opt_local.tabstop = size
    vim.opt_local.shiftwidth = size
    vim.opt_local.softtabstop = size
    vim.opt_local.expandtab = true
  end,
})



vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true

vim.opt.guicursor = "n-v-c:block"

local group = vim.api.nvim_create_augroup("CursorShape", {})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function()
    vim.opt.guicursor = ""
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function()
    vim.opt.guicursor = "n-v-c:block"
  end,
})






-- Keymap settings --
-- Brackets keymap --
vim.keymap.set('i', '{', '{}<Left>', { noremap = true })
vim.keymap.set('i', '{{', '{', { noremap = true })
vim.keymap.set('i', '{}', '{}', { noremap = true })

vim.keymap.set('i', '{<CR>', function()
  return '{<CR>}<Esc>O'
end, { expr = true, noremap = true })

-- Shortcut --
vim.keymap.set('n', '<C-a>', 'gg0vG$', { noremap = true, silent = true })
vim.keymap.set('i', '<C-a>', '<Esc>gg0vG$', { noremap = true, silent = true })

vim.keymap.set('n', '<S-Tab>', ':tabnext<CR>', { noremap = true, silent = true })

-- Terminal toggle
vim.keymap.set("n", "<F2>", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_win_close(win, true)
			return
		end
	end

	vim.cmd("vsplit")
	vim.cmd("terminal")
	vim.cmd("startinsert")
end, { desc = "Toggle terminal" })






-- =========================================================
-- Competitive Programming
-- =========================================================
--
-- Layout:
--
--   sol.cpp          | sol.inp
--                    |
--                    |
--                    |
--                    |
--
-- Right side = ONE window
--
--     .inp
--       <----> terminal
--
--
-- F8:
--     Show .inp + focus .inp
--
-- F9:
--     Save
--     Run `ric`
--
--     .inp has input:
--         -> run with .inp
--         -> focus back to .cpp
--
--     .inp is empty:
--         -> run interactive
--         -> focus terminal
--
-- Ctrl+h in terminal:
--     -> go to .cpp
--
-- Ctrl+l:
--     -> go to right panel
--
-- =========================================================



-- =========================================================
-- Files
-- =========================================================

local function cp_get_files()

    local cpp_file = vim.api.nvim_buf_get_name(0)

    -- -----------------------------------------------------
    -- If current buffer isn't .cpp,
    -- search opened buffers in current tab.
    -- -----------------------------------------------------

    if not cpp_file:match("%.cpp$") then
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
                local name =
                    vim.api.nvim_buf_get_name(buf)
                if name:match("%.cpp$") then
                    cpp_file = name
                    break
                end
            end
        end
    end


    if cpp_file == ""
        or not cpp_file:match("%.cpp$")
    then
        return nil
    end

    local base =
        vim.fn.fnamemodify(cpp_file, ":r")

    return {
        cpp = cpp_file,
        inp = base .. ".inp",
        program = base,
    }

end



-- =========================================================
-- Save cpp
-- =========================================================

local function cp_save_cpp(files)

    local cpp_buf =
        vim.fn.bufnr(files.cpp)

    if cpp_buf == -1 then
        return false
    end

    if not vim.api.nvim_buf_is_valid(cpp_buf) then
        return false
    end

    vim.api.nvim_buf_call(
        cpp_buf,
        function()
            vim.cmd("write")
        end
    )

    return true

end



-- =========================================================
-- Get .cpp window
-- =========================================================

local function cp_get_cpp_win()

    local files = cp_get_files()

    if not files then
        return nil
    end

    local cpp_buf =
        vim.fn.bufnr(files.cpp)

    if cpp_buf == -1 then
        return nil
    end

    for _, win in ipairs(
        vim.api.nvim_tabpage_list_wins(0)
    ) do

        if vim.api.nvim_win_get_buf(win)
            == cpp_buf
        then
            return win
        end
    end

    return nil

end



-- =========================================================
-- Get right-side window
-- =========================================================

local function cp_get_right_win()

    if vim.t.cp_right_win
        and vim.api.nvim_win_is_valid(
            vim.t.cp_right_win
        )
    then
        return vim.t.cp_right_win
    end

    return nil

end



-- =========================================================
-- Get terminal buffer
-- =========================================================

local function cp_get_terminal_buf()

    if vim.t.cp_terminal_buf
        and vim.api.nvim_buf_is_valid(
            vim.t.cp_terminal_buf
        )
    then

        if vim.bo[
            vim.t.cp_terminal_buf
        ].buftype == "terminal"
        then
            return vim.t.cp_terminal_buf
        end
    end

    return nil

end



-- =========================================================
-- Get input buffer
-- =========================================================

local function cp_get_input_buf()

    local files = cp_get_files()

    if not files then
        return nil
    end

    local buf =
        vim.fn.bufnr(files.inp)

    if buf == -1 then

        buf = vim.fn.bufadd(files.inp)

        vim.fn.bufload(buf)
    end

    return buf

end



-- =========================================================
-- Set terminal colors
-- =========================================================

local function cp_set_terminal_colors()

    local win =
        cp_get_right_win()

    if not win then
        return
    end

    vim.wo[win].winhl =
        "Normal:TermNormal,NormalNC:TermNormal"

end



-- =========================================================
-- Set normal editor colors
-- =========================================================

local function cp_set_editor_colors()

    local win =
        cp_get_right_win()

    if not win then
        return
    end

    vim.wo[win].winhl = ""

end



-- =========================================================
-- Show .inp
-- =========================================================

local function cp_show_input()

    local win =
        cp_get_right_win()

    if not win then
        return false
    end

    local buf =
        cp_get_input_buf()

    if not buf then
        return false
    end

    vim.api.nvim_win_set_buf(
        win,
        buf
    )

    cp_set_editor_colors()

    vim.t.cp_right_mode = "input"


    return true

end



-- =========================================================
-- Show terminal
-- =========================================================

local function cp_show_terminal()

    local win =
        cp_get_right_win()

    local terminal_buf =
        cp_get_terminal_buf()

    if not win or not terminal_buf then
        return false
    end

    vim.api.nvim_win_set_buf(
        win,
        terminal_buf
    )

    cp_set_terminal_colors()

    vim.t.cp_right_mode = "terminal"

    return true

end



-- =========================================================
-- Focus .cpp
-- =========================================================

local function cp_focus_cpp()

    local win =
        cp_get_cpp_win()

    if win
        and vim.api.nvim_win_is_valid(win)
    then
        vim.api.nvim_set_current_win(win)
        return true
    end

    return false

end



-- =========================================================
-- Focus .inp
-- =========================================================

local function cp_focus_input()

    if not cp_show_input() then
        return false
    end

    local win =
        cp_get_right_win()

    if win
        and vim.api.nvim_win_is_valid(win)
    then

        vim.api.nvim_set_current_win(win)
        return true
    end

    return false

end



-- =========================================================
-- Focus terminal
-- =========================================================

local function cp_focus_terminal()

    if not cp_show_terminal() then
        return false
    end

    local win =
        cp_get_right_win()

    if win
        and vim.api.nvim_win_is_valid(win)
    then
        vim.api.nvim_set_current_win(win)
        vim.cmd("startinsert")
        return true
    end

    return false

end



-- =========================================================
-- Send command to terminal
-- =========================================================

local function cp_terminal_send(command)

    local terminal_buf =
        cp_get_terminal_buf()

    if not terminal_buf then
        vim.notify(
            "CP terminal not found",
            vim.log.levels.ERROR
        )
        return false
    end

    local channel =
        vim.bo[terminal_buf].channel

    if not channel or channel == 0 then
        vim.notify(
            "CP terminal channel not found",
            vim.log.levels.ERROR
        )
        return false
    end

    vim.api.nvim_chan_send(
        channel,
        command .. "\n"
    )

    return true

end



-- =========================================================
-- F8
--
-- Show .inp
-- Focus .inp
-- =========================================================

vim.keymap.set("n", "<F8>", function()

    if not cp_focus_input() then
        vim.notify(
            "Cannot open .inp",
            vim.log.levels.ERROR
        )
        return
    end

end, {
    desc = "CP: Focus input",
})



-- =========================================================
-- F9
--
-- Save
-- Run ric
--
-- Input exists:
--     terminal stays visible
--     focus -> cpp
--
-- Input empty:
--     terminal stays visible
--     focus -> terminal
--
-- =========================================================

vim.keymap.set("n", "<F9>", function()

    local files =
        cp_get_files()

    if not files then
        vim.notify(
            "Cannot find .cpp file",
            vim.log.levels.ERROR
        )
        return
    end

    -- -----------------------------------------------------
    -- Save cpp
    -- -----------------------------------------------------

    if not cp_save_cpp(files) then
        vim.notify(
            "Cannot save " .. files.cpp,
            vim.log.levels.ERROR
        )
        return
    end

    -- -----------------------------------------------------
    -- Make sure .inp exists
    -- -----------------------------------------------------

    if vim.fn.filereadable(files.inp) ~= 1 then
        vim.fn.writefile(
            {},
            files.inp
        )
    end


    -- -----------------------------------------------------
    -- Check whether input is empty
    -- -----------------------------------------------------

    local inp_empty =
        vim.fn.getfsize(files.inp) <= 0

    -- -----------------------------------------------------
    -- Show terminal
    -- -----------------------------------------------------

    if not cp_show_terminal() then
        vim.notify(
            "CP terminal not found",
            vim.log.levels.ERROR
        )
        return
    end

    -- -----------------------------------------------------
    -- Run existing bash function
    --
    --     ric /absolute/path/to/sol
    --
    -- `ric` is defined in ~/.bashrc
    -- -----------------------------------------------------

    local command =
        string.format(
            "bash -ic 'ric %q'",
            files.program
        )

    if not cp_terminal_send(command) then
        return
    end

    -- -----------------------------------------------------
    -- Focus
    -- -----------------------------------------------------

    if inp_empty then
        -- Interactive input:
        -- user needs terminal immediately

        cp_focus_terminal()
    else
        -- Input comes from file:
        -- return to code

        cp_focus_cpp()
    end

end, {
    desc = "CP: Compile & Run",
})



-- =========================================================
-- Ctrl+h
--
-- Terminal -> .cpp
--
-- Terminal mode needs its own mapping because
-- Ctrl+h would otherwise be sent to the shell.
-- =========================================================

vim.keymap.set("t", "<C-h>", function()

    -- Leave terminal mode
    vim.api.nvim_feedkeys(
        vim.keycode("<C-\\><C-n>"),
        "n",
        false
    )

    vim.schedule(function()
        cp_focus_cpp()
    end)

end, {
    desc = "CP: Terminal -> Code",
})



-- =========================================================
-- Ctrl+l
--
-- Terminal / code -> right panel
-- =========================================================

vim.keymap.set("n", "<C-l>", function()

    local win =
        cp_get_right_win()

    if win
        and vim.api.nvim_win_is_valid(win)
    then
        vim.api.nvim_set_current_win(win)
    end

end, {
    desc = "CP: Go to right panel",
})



-- Terminal mode Ctrl+l
vim.keymap.set("t", "<C-l>", function()

    vim.api.nvim_feedkeys(
        vim.keycode("<C-\\><C-n>"),
        "n",
        false
    )

    vim.schedule(function()
        local win =
            cp_get_right_win()

        if win
            and vim.api.nvim_win_is_valid(win)
        then
            vim.api.nvim_set_current_win(win)
        end
    end)

end, {
    desc = "CP: Terminal -> right panel",
})



-- =========================================================
-- Layout
--
--   sol.cpp          | sol.inp
--                    |
--                    |
--                    |
--                    |
--
-- Right side is ONE window.
--
-- .inp and terminal occupy exactly
-- the same window.
-- =========================================================

local cpp_layout =
    vim.api.nvim_create_augroup(
        "CppInputTerminalLayout",
        {
            clear = true,
        }
    )



vim.api.nvim_create_autocmd(
    "BufEnter",
    {
        group = cpp_layout,
        pattern = "*.cpp",

        callback = function(args)

            -- -------------------------------------------------
            -- Don't recreate layout
            -- -------------------------------------------------

            if vim.t.cp_layout_created then
                return
            end


            local cpp_file =
                vim.api.nvim_buf_get_name(
                    args.buf
                )


            if cpp_file == "" then
                return
            end


            local base =
                vim.fn.fnamemodify(
                    cpp_file,
                    ":r"
                )


            local inp_file =
                base .. ".inp"

            -- -------------------------------------------------
            -- Create .inp if missing
            -- -------------------------------------------------

            if vim.fn.filereadable(inp_file)
                ~= 1
            then
                vim.fn.writefile(
                    {},
                    inp_file
                )
            end

            -- -------------------------------------------------
            -- Remember cpp window
            -- -------------------------------------------------

            local cpp_win =
                vim.api.nvim_get_current_win()

            -- -------------------------------------------------
            -- Create right-side window
            -- -------------------------------------------------

            vim.cmd(
                "rightbelow 80vsplit"
            )


            local right_win =
                vim.api.nvim_get_current_win()

            vim.t.cp_right_win =
                right_win

            -- -------------------------------------------------
            -- Open .inp
            -- -------------------------------------------------

            local inp_buf =
                vim.fn.bufadd(inp_file)

            vim.fn.bufload(inp_buf)

            vim.api.nvim_win_set_buf(
                right_win,
                inp_buf
            )

            vim.t.cp_right_mode =
                "input"

            -- -------------------------------------------------
            -- Create terminal buffer
            --
            -- We temporarily replace the right window.
            -- No second split is created.
            -- -------------------------------------------------

            vim.cmd("enew")
            vim.cmd("terminal")

            local terminal_buf =
                vim.api.nvim_get_current_buf()

            vim.t.cp_terminal_buf =
                terminal_buf

            vim.bo[
                terminal_buf
            ].buflisted = false

            -- -------------------------------------------------
            -- Put .inp back
            -- -------------------------------------------------

            vim.api.nvim_win_set_buf(
                right_win,
                inp_buf
            )

            cp_set_editor_colors()

            vim.t.cp_right_mode =
                "input"

            -- -------------------------------------------------
            -- Mark layout
            -- -------------------------------------------------

            vim.t.cp_layout_created =
                true

            -- -------------------------------------------------
            -- Return to cpp
            -- -------------------------------------------------

            vim.api.nvim_set_current_win(
                cpp_win
            )

        end,
    }
)






vim.opt.showtabline = 1
vim.opt.laststatus = 0
vim.o.statusline = " %F %m%=%L Ln | Row %l, Col %c "






-- Tree-sitter
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "java", "python", "lua" },
    callback = function(args)
        vim.treesitter.start(args.buf)
    end,
})



-- Terminal color
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.wo.winhl = "Normal:TermNormal,NormalNC:TermNormal"
    end,
})






-- Syntax highlight
local M = {}
function M.setup()
	vim.opt.termguicolors = true

	local colors = {
		black = "#000000",
		bright_black = "#808080",
		white = "#EEEEEE",
		bright_white = "#FFFFFF",
		red = "#800000",
		bright_red = "#FF0000",
		green = "#008000",
		bright_green = "#00FF00",
		yellow = "#808000",
		bright_yellow = "#FFFF00",
		blue = "#000080",
		bright_blue = "#00DDFF",
		purple = "#800080",
		bright_purple = "#FF00FF",
		cyan = "#2E8B7C",
		bright_cyan = "#00FFFF",
	}
	local highlight = {
		Normal = { fg=colors.bright_white, bg=colors.blue },
		LineNr = { fg=colors.bright_yellow},
		CursorLine = { bg=colors.cyan },
		Cursor = { bg="#FFFF7F" },
		CursorInsert = { bg="#FFFF7F" },
		CursorReplace = { bg="#FFFF7F" },
		ModeMsg = { fg=colors.cyan, bold=true },
		TermNormal = { fg=colors.bright_white, bg=colors.black },

		Comment = { fg=colors.cyan },
		Constant = { fg=colors.bright_green },
		cConstant = { fg=colors.bright_blue },
		cIncluded = { fg=colors.bright_red },
		Special = { fg=colors.bright_green },
		String = { fg=colors.bright_yellow },

		Keyword = { fg=colors.bright_white },
		Statement = { fg=colors.bright_white },
		Type = { fg=colors.bright_white },
		PreProc = { fg=colors.bright_green },
		Function = { fg=colors.bright_blue },
        Delimiter = { fg=colors.bright_white },
		Identifier = { fg=colors.bright_blue },

		Error = { fg=colors.bright_white, bg=colors.bright_red },
		Todo = { fg=colors.black, bg=colors.yellow },
		Title = { fg=colors.bright_yellow },

		Visual = { fg=colors.black, bg=colors.cyan },
		MatchParen = { fg=colors.bright_red },
		NonText = { fg=colors.bright_blue },
		CurSearch = { fg=colors.black, bg=colors.yellow },

		WarningMsg = { fg=colors.bright_red },
		ErrorMsg = { fg=colors.bright_white, bg=colors.bright_red, bold=true },
		MoreMsg = { fg=colors.cyan },
		Question = { fg=colors.cyan },

		TabLine = { fg=colors.black, bg=colors.cyan },
		TabLineSel = { fg=colors.bright_white, bg=colors.black },
		TabLineFill = { bg=colors.cyan },
		Pmenu = { fg=colors.black, bg=colors.bright_black },
		PmenuSel = { fg=colors.black, bg=colors.cyan },

		Statusline = { fg=colors.bright_white, bg=colors.black },
		StatuslineNC = { fg=colors.black, bg=colors.cyan },



		-- This part is just for who installed Tree-sitter
        -- Tree-sitter: default
        ["@variable"] = { fg=colors.bright_white },
        ["@operator"] = { fg=colors.bright_white },

		-- Tree-sitter: lua
		["@property.lua"] = { fg=colors.bright_white },
		["@variable.member.lua"] = { fg=colors.bright_blue },

		-- Tree-sitter: cpp
		["@function.cpp"] = { fg=colors.bright_white },
		["@type.builtin.cpp"] = { fg=colors.bright_white},
		["@variable.cpp"] = { fg=colors.bright_blue },
		["@character.cpp"] = { fg=colors.bright_yellow },
		["@string.escape.cpp"] = { fg=colors.bright_yellow },
		["@keyword.import.cpp"] = { fg=colors.bright_green },
		["@keyword.directive.cpp"] = { fg=colors.bright_green },
		["@keyword.directive.define.cpp"] = { fg=colors.bright_green },
        ["@boolean.cpp"] = { fg=colors.bright_white },
        ["@function.macro.cpp"] = { fg=colors.bright_green },
		
	}

	for group, opts in pairs(highlight) do
		vim.api.nvim_set_hl(0, group, opts)
	end
    -- Custom Highlighting
    -- CP
    local custom_matches = {
        -- punctuation
        {
            patterns = {
                [[{]],
                [[}]],
                [[;]],
                [[::]],
            },
            fg = colors.bright_yellow,
        },

        -- library
        {
            patterns = {
                -- more library
                [[#include\s\+<\zs[^>]\+\ze>]],
                [[#include\s\+"\zs[^"]\+\ze"]],
            },
            fg=colors.bright_red,
        },

        -- ' and "
        {
            patterns = {
                [[']],
                [["]],
            },
            fg=colors.yellow,
        },

        -- less color on basic i/o c++
        {
            patterns = {
                [[\<cin\>]],
                [[\<cout\>]],
                [[\<printf\>]],
                [[\<scanf\>]],
                [[\<endl\>]],
                [[\<cerr\>]],
                [[\V>>]],
                [[\V<<]],
            },
            fg = colors.bright_white,
        },

    }

    for i, item in ipairs(custom_matches) do
        local group = "CustomHighlight" .. i

        vim.api.nvim_set_hl(0, group, {
            fg = item.fg,
            bg = item.bg,
            bold = item.bold,
            italic = item.italic,
        })

        for _, pattern in ipairs(item.patterns) do
            vim.fn.matchadd(group, pattern, 100)
        end
    end
end

M.setup()



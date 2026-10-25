-- ============================================================
-- SYSTEM / PLUGIN MANAGER
-- ============================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)


-- ============================================================
-- PLUGINS
-- ============================================================

require("lazy").setup({

  -- ==========================================================
  -- ONEDARK
  -- ==========================================================

  {
    "navarasu/onedark.nvim",
    name = "onedark",
    priority = 1000,

    config = function()
      require("onedark").setup({
        style = "dark",
      })

      require("onedark").load()
    end,
  },


  -- ==========================================================
  -- WEB DEVICONS
  -- ==========================================================

  {
    "nvim-tree/nvim-web-devicons",
  },


  -- ==========================================================
  -- LUALINE
  -- ==========================================================

  {
    "nvim-lualine/lualine.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      options = {
        theme = "onedark",
        globalstatus = true,

        section_separators = {
          left = "",
          right = "",
        },

        component_separators = {
          left = "│",
          right = "│",
        },
      },

      sections = {
        lualine_a = {
          {
            "mode",

            color = function()
              local colors = {
                n = "#98c379",
                i = "#61afef",
                v = "#c678dd",
                V = "#c678dd",
                ["\22"] = "#c678dd",
                R = "#e06c75",
                c = "#e5c07b",
              }

              return {
                fg = "#282c34",
                bg = colors[vim.fn.mode()] or "#98c379",
                gui = "bold",
              }
            end,
          },
        },

        lualine_b = {
          {
            "filename",
            path = 0,

            symbols = {
              modified = " [+]",
              readonly = " [RO]",
              unnamed = "[No Name]",
            },
          },
        },

        lualine_c = {},

        lualine_x = {
          {
            "filetype",
            fmt = string.lower,
          },

          "encoding",
          "location",
          "progress",
        },

        lualine_y = {},
        lualine_z = {},
      },
    },
  },


  -- ==========================================================
  -- OIL.NVIM
  -- ==========================================================

  {
    "stevearc/oil.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      default_file_explorer = true,

      columns = {
        "icon",
      },

      view_options = {
        show_hidden = true,
      },
    },

    keys = {
      {
        "mo",
        "<CMD>Oil<CR>",
        desc = "Open File Manager",
      },
    },
  },


  -- ==========================================================
  -- MASON
  -- ==========================================================

  {
    "mason-org/mason.nvim",
    opts = {},
  },


  -- ==========================================================
  -- MASON LSPCONFIG
  -- ==========================================================

  {
    "mason-org/mason-lspconfig.nvim",

    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },

    opts = {
      ensure_installed = {
        "rust_analyzer",
        "ts_ls",
        "html",
      },

      automatic_enable = true,
    },
  },


  -- ==========================================================
  -- LSPCONFIG
  -- ==========================================================

  {
    "neovim/nvim-lspconfig",

    lazy = false,

    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      local capabilities =
        require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
      })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("html", {
        capabilities = capabilities,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {
        desc = "LSP Hover",
      })

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
        desc = "Go to Definition",
      })
    end,
  },


  -- ==========================================================
  -- NVIM-CMP
  -- ==========================================================

  {
    "hrsh7th/nvim-cmp",

    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },

    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),

          ["<CR>"] = cmp.mapping.confirm({
            select = true,
          }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim-lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

}, {
  checker = {
    enabled = false,
  },
})


-- ============================================================
-- EDITOR SETTINGS
-- ============================================================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true
vim.opt.cursorline = false
vim.opt.wrap = false
vim.opt.encoding = "utf-8"
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.showtabline = 2
vim.opt.laststatus = 3



-- ============================================================
-- BACKUP / UNDO
-- ============================================================

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true


-- ============================================================
-- KEYMAPS
-- ============================================================

-- ------------------------------------------------------------
-- Brackets
-- ------------------------------------------------------------

vim.keymap.set("i", "{", "{}<Left>", {
  noremap = true,
})

vim.keymap.set("i", "{{", "{", {
  noremap = true,
})

vim.keymap.set("i", "{}", "{}", {
  noremap = true,
})

vim.keymap.set("i", "{<CR>", function()
  return "{<CR>}<Esc>O"
end, {
  expr = true,
  noremap = true,
})


-- ------------------------------------------------------------
-- Select All
-- ------------------------------------------------------------

vim.keymap.set("n", "<C-a>", "gg0vG$", {
  noremap = true,
  silent = true,
})

vim.keymap.set("i", "<C-a>", "<Esc>gg0vG$", {
  noremap = true,
  silent = true,
})


-- ------------------------------------------------------------
-- Oil: D:/CP/
-- ------------------------------------------------------------

vim.keymap.set("n", "cp", function()
  require("oil").open("D:/CP/")
end)


-- ------------------------------------------------------------
-- Next Tab
-- ------------------------------------------------------------

vim.keymap.set("n", "<C-Tab>", ":tabnext<CR>", {
  noremap = true,
  silent = true,
})


-- ============================================================
-- LINE NUMBER TOGGLE
-- ============================================================

local number_toggle_group = vim.api.nvim_create_augroup(
  "NumberToggle",
  {
    clear = true,
  }
)

local line_number_enabled = true


vim.keymap.set("n", "<F4>", function()
  line_number_enabled = not line_number_enabled

  vim.opt.number = line_number_enabled
  vim.opt.relativenumber = line_number_enabled
end, {
  silent = true,
  desc = "Toggle line numbers",
})


vim.api.nvim_create_autocmd("InsertEnter", {
  group = number_toggle_group,

  callback = function()
    vim.opt.number = line_number_enabled
    vim.opt.relativenumber = false
  end,
})


vim.api.nvim_create_autocmd("InsertLeave", {
  group = number_toggle_group,

  callback = function()
    vim.opt.number = line_number_enabled
    vim.opt.relativenumber = line_number_enabled
  end,
})


-- ============================================================
-- COLORS
-- ============================================================

vim.cmd.colorscheme("onedark")


-- ============================================================
-- TABLINE COLORS
-- ============================================================

vim.api.nvim_set_hl(0, "TabLineSel", {
  fg = "#282c34",
  bg = "#98c379",
  bold = true,
})

vim.api.nvim_set_hl(0, "TabLine", {
  fg = "#abb2bf",
  bg = "#5c6370",
})

vim.api.nvim_set_hl(0, "TabLineFill", {
  fg = "#abb2bf",
  bg = "#282c34",
})


-- ============================================================
-- CUSTOM TABLINE
-- ============================================================

local devicons = require("nvim-web-devicons")


function MyTabline()
  local result = ""
  local tab_count = vim.fn.tabpagenr("$")
  local current_tab = vim.fn.tabpagenr()

  for i = 1, tab_count do
    local selected = i == current_tab

    -- --------------------------------------------------------
    -- Buffer
    -- --------------------------------------------------------

    local win = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[win]

    -- --------------------------------------------------------
    -- File name
    -- --------------------------------------------------------

    local name = vim.fn.bufname(bufnr)

    if name == "" then
      name = "[No Name]"
    else
      name = vim.fn.fnamemodify(name, ":t")
    end

    -- --------------------------------------------------------
    -- Tab highlight
    -- --------------------------------------------------------

    result = result
      .. (selected and "%#TabLineSel#" or "%#TabLine#")
      .. " "

    -- --------------------------------------------------------
    -- Icon
    -- --------------------------------------------------------

    local ext = vim.fn.fnamemodify(name, ":e")

    local icon = devicons.get_icon(name, ext, {
      default = true,
    })

    if icon then
      result = result .. icon .. " "
    end

    -- --------------------------------------------------------
    -- File name
    -- --------------------------------------------------------

    result = result .. name .. " "

    -- --------------------------------------------------------
    -- Separator
    -- --------------------------------------------------------

    if i < tab_count then
      result = result .. "%#TabLine#│"
    end
  end

  -- ----------------------------------------------------------
  -- Fill
  -- ----------------------------------------------------------

  return result .. "%#TabLineFill#%T"
end


-- ============================================================
-- ACTIVATE TABLINE
-- ============================================================

vim.o.tabline = "%!v:lua.MyTabline()"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Adiciona LazyVim e importa seus plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "bash",
          "html",
          "javascript",
          "lua",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
      },
    },
    -- Importa/sobrescreve com seus próprios plugins
    { import = "plugins" },

    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local telescope = require("telescope")
        local telescope_builtin = require("telescope.builtin")

        telescope.setup({
          pickers = {
            buffers = {
              sort_mru = true,
            },
          },
        })

        vim.keymap.set("n", "<leader><leader>", function()
          telescope_builtin.buffers({ sort_mru = true })
        end)
      end,
    },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- {
    --   "neovim/nvim-lspconfig",
    --   opts = {
    --     servers = { eslint = {}, tsserver = {} },
    --     setup = {
    --       eslint = function()
    --         require("lazyvim.util").lsp.on_attach(function(client)
    --           if client.name == "eslint" then
    --             client.server_capabilities.documentFormattingProvider = true
    --           elseif client.name == "tsserver" then
    --             client.server_capabilities.documentFormattingProvider = false
    --           end
    --         end)
    --       end,
    --     },
    --   },
    -- },

    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },

    {

      "nvim-neo-tree/neo-tree.nvim",

      branch = "v3.x",

      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
      },
    },
  },

  defaults = {
    lazy = false,
    version = false, -- sempre usar o último commit do Git
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- verificar atualizações de plugins periodicamente
    notify = false, -- notificar sobre atualizações
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle NeoTree" })

-- Mapeamento de teclas para o comando Telescope live_grep

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<C-a>", "ggVG")

vim.keymap.set("n", "<leader>rf", vim.lsp.buf.rename, { desc = "LSP Rename (File, No Confirm)" })

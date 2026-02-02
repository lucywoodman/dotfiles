-- Plugin specifications for lazy.nvim
-- ====================================

return {
  -- ===== Colorscheme (everforest) =====
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme("everforest")
    end,
  },

  -- ===== Statusline =====
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "everforest",
        component_separators = "|",  -- separator = "|" from Helix
        section_separators = "",
      },
      sections = {
        -- left = ["mode", "spinner", "version-control"]
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        -- center = ["file-name", "file-modification-indicator"]
        lualine_c = { { "filename", path = 0 } },
        -- right = ["file-type", "selections", "position", "file-encoding"]
        lualine_x = { "filetype" },
        lualine_y = { "encoding" },
        lualine_z = { "location" },
      },
    },
  },

  -- ===== Bufferline =====
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- ===== Treesitter (syntax highlighting) =====
  {
    "nvim-treesitter/nvim-treesitter",
    -- Install parsers on plugin install/update
    build = ":TSInstall javascript typescript tsx python rust go json yaml toml bash",
    config = function()
      -- Enable treesitter highlighting for all filetypes (Neovim 0.11+ native)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- ===== Indent guides =====
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  -- ===== Git signs (for version-control in statusline) =====
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- ===== Mason (LSP server installer) =====
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- ===== LSP (using native vim.lsp.config for Neovim 0.11+) =====
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      -- LSP keymaps (set up on LspAttach event)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          -- LSP keymaps
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          -- Inlay hints (display-inlay-hints = true from Helix)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
        end,
      })

      -- Configure LSP servers using native vim.lsp.config (Neovim 0.11+)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.config("ts_ls", {})
      vim.lsp.config("pyright", {})
      vim.lsp.config("rust_analyzer", {})

      -- Go
      vim.lsp.config("gopls", {})

      -- PHP
      vim.lsp.config("intelephense", {})

      -- Bash
      vim.lsp.config("bashls", {})

      -- JSON (with schema support)
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      })

      -- YAML (with common schema support)
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            validate = true,
            schemaStore = { enable = true },
          },
        },
      })

      -- Markdown
      vim.lsp.config("marksman", {})

      -- Ruby
      vim.lsp.config("solargraph", {})

      -- Enable configured servers
      vim.lsp.enable({
        "lua_ls",
        "ts_ls",
        "pyright",
        "rust_analyzer",
        "gopls",
        "intelephense",
        "bashls",
        "jsonls",
        "yamlls",
        "marksman",
        "solargraph",
      })
    end,
  },

  -- ===== Linting =====
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Configure linters by filetype
      -- These call CLI tools directly (must be in PATH)
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        python = { "ruff" },
        php = { "phpcs" },
        -- ruby = { "rubocop" },
        -- go = { "golangcilint" },
      }

      -- Run linters on save and when entering a buffer
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        group = vim.api.nvim_create_augroup("Linting", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- ===== Debugging (DAP) =====
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue/Start debugging" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last config" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate session" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup UI and virtual text
      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- Auto open/close UI with debug session
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- PHP adapter (requires: MasonInstall php-debug-adapter)
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
        },
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug (Docker)",
          port = 9003,
          pathMappings = {
            ["/var/www"] = vim.fn.getcwd(),
          },
        },
      }
    end,
  },

  -- ===== Autocompletion =====
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- ===== Telescope (fuzzy finder) =====
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    },
  },

  -- ===== Which-key (discover keybindings) =====
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- ===== File Explorer (tree sidebar) =====
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false, -- Load immediately so it opens on startup
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current", -- Replace netrw
      },
      window = {
        position = "left",
        width = 30,
      },
    },
    init = function()
      -- Open neo-tree on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            -- No file arguments: open neo-tree showing cwd
            vim.cmd("Neotree show")
          else
            -- File arguments: open neo-tree and reveal current file
            vim.cmd("Neotree show reveal")
          end
        end,
      })
    end,
  },
}

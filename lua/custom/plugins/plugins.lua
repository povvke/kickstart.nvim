return {
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'normal',

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } }

      -- experimental signature help support
      trigger = { signature_help = { enabled = true } },
      keymap = {
        hide = "<Esc>"
      }
    }
  },
  -- { 'hrsh7th/nvim-cmp',  enabled = false },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime"
      }
    },
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "v", desc = "Add cursor above" }, "<C-k>",
        function() mc.lineAddCursor(-1) end)
      set({ "n", "v", desc = "Add cursor below" }, "<C-j>",
        function() mc.lineAddCursor(1) end)
      set({ "n", "v", desc = "Skip cursor above" }, "<leader><up>",
        function() mc.lineSkipCursor(-1) end)
      set({ "n", "v", desc = "Skip cursor below" }, "<leader><down>",
        function() mc.lineSkipCursor(1) end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "v", desc = "Match word and add cursor" }, "<leader>n",
        function() mc.matchAddCursor(1) end)
      set({ "n", "v", desc = "Match word and skip cursor" }, "<leader>s",
        function() mc.matchSkipCursor(1) end)
      set({ "n", "v", desc = "Match word and add every other cursor" }, "<leader>N",
        function() mc.matchAddCursor(-1) end)
      set({ "n", "v", desc = "Match word and skip every other word" }, "<leader>S",
        function() mc.matchSkipCursor(-1) end)

      -- Add all matches in the document
      set({ "n", "v", desc = "Match word and add all cursors" }, "<leader>A", mc.matchAllAddCursors)

      -- You can also add cursors with any motion you prefer:
      -- set("n", "<right>", function()
      --     mc.addCursor("w")
      -- end)
      -- set("n", "<leader><right>", function()
      --     mc.skipCursor("w")
      -- end)

      -- Rotate the main cursor.
      set({ "n", "v" }, "<left>", mc.nextCursor)
      set({ "n", "v" }, "<right>", mc.prevCursor)

      -- Delete the main cursor.
      set({ "n", "v", desc = "Delete main cursor" }, "<leader>x", mc.deleteCursor)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)

      -- Easy way to add and remove cursors using the main cursor.
      set({ "n", "v", desc = "Toggle cursors" }, "<c-q>", mc.toggleCursor)

      -- Clone every cursor and disable the originals.
      set({ "n", "v", desc = "Duplicate cursors and disable originals" }, "<leader><c-q>", mc.duplicateCursors)

      set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)

      set("n", "<C-g>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)

      -- bring back cursors if you accidentally clear them
      set("n", "<leader>gv", mc.restoreCursors, { desc = "Restore multiple cursors" })

      -- Align cursor columns.
      set("n", "<leader>a", mc.alignCursors, { desc = "Align cursor columns" })

      -- Split visual selections by regex.
      set("v", "S", mc.splitCursors)

      -- Append/insert for each line of visual selections.
      set("v", "I", mc.insertVisual)
      set("v", "A", mc.appendVisual)

      -- match new cursors within visual selections by regex.
      set("v", "M", mc.matchCursors)

      -- Rotate visual selection contents.
      set({ "v", desc = "Rotate selection to right" }, "<leader>t",
        function() mc.transposeCursors(1) end)
      set({ "v", desc = "Rotate selection to left" }, "<leader>T",
        function() mc.transposeCursors(-1) end)

      -- Jumplist support
      set({ "v", "n" }, "<c-i>", mc.jumpForward)
      set({ "v", "n" }, "<c-o>", mc.jumpBackward)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end
  },

  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "echasnovski/mini.pick",         -- optional
    },
    config = true
  },
  { "dm1try/golden_size" },
  {
    "windwp/nvim-ts-autotag",
    event = 'InsertEnter',
  },
  {
    "j-morano/buffer_manager.nvim",
    event = 'BufAdd',
    config = function()
      local bm = require("buffer_manager")
      bm.setup({
        select_menu_item_commands = {
          g = {
            key = "<C-g>",
            command = "<Esc>"
          }
        },

      })
    end


  }
}

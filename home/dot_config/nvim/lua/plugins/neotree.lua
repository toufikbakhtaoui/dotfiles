return {
  -- Main Neo-tree plugin
  'nvim-neo-tree/neo-tree.nvim',

  branch = 'v3.x', -- Use the latest v3.x branch

  dependencies = {
    'nvim-lua/plenary.nvim',          -- Utility functions
    'nvim-tree/nvim-web-devicons',    -- File and folder icons
    'MunifTanjim/nui.nvim',           -- UI components
  },

  config = function()
    -- Define diagnostic icons (optional)
    vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn',  { text = ' ', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo',  { text = ' ', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint',  { text = '󰌵', texthl = 'DiagnosticSignHint' })

    require('neo-tree').setup {
      -- General options
      close_if_last_window = true, -- Close Neo-tree if it's the last window
      enable_git_status = true,    -- Show git changes
      enable_diagnostics = true,   -- Show LSP diagnostics

      -- Window settings
      window = {
        position = 'left',
        width = 30,
        mappings = {
          ['<cr>'] = 'open',        -- Enter to open file
          ['l'] = 'open',           -- l to open file
          ['h'] = 'close_node',     -- h to collapse folder
          ['a'] = 'add',            -- Create new file
          ['d'] = 'delete',         -- Delete file
          ['r'] = 'rename',         -- Rename file
          ['q'] = 'close_window',   -- Close Neo-tree
          ['R'] = 'refresh',        -- Refresh tree
        },
      },

      -- Filesystem settings
      filesystem = {
        filtered_items = {
          visible = false, -- Do not show hidden files by default
          hide_dotfiles = true,
          hide_gitignored = true,
        },
        follow_current_file = { enabled = true }, -- Auto-focus the current file
        hijack_netrw_behavior = 'open_default',   -- Replace netrw
      },

      -- Buffers source (manage open files)
      buffers = {
        follow_current_file = { enabled = true },
      },
    }

    -- Keybinding to toggle Neo-tree globally
    vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })
  end,
}


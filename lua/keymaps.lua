-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Custom Keymaps ]]
-- Move highlighted text up and down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Move line up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Move line down' })

-- Keep visual selection after indenting
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = 'Indent right and reselect' })

-- Replace word under the cursor
vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })

-- Copy current file relative path
vim.keymap.set('n', '<leader>fy', function()
  local path = vim.fn.expand '%:.'
  vim.fn.setreg('+', path)
  print('Copied: ' .. path)
end, { noremap = true, silent = true, desc = 'Copy file relative path' })

-- Delete buffer
vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>', { noremap = true, silent = true, desc = 'Delete buffer' })

-- [[ Git Keymaps ]]
-- Yank GitHub URL for current file and line
vim.keymap.set('n', '<leader>gy', function()
  local filepath = vim.fn.expand '%:p'
  local line_num = vim.fn.line '.'
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.expand '%:p:h') .. ' rev-parse --show-toplevel')[1]

  if not git_root or git_root == '' then
    print('Not in a git repository')
    return
  end

  -- Get relative path from git root
  local relative_path = filepath:sub(#git_root + 2)

  -- Get remote URL
  local remote_url = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(git_root) .. ' remote get-url origin')[1]
  if not remote_url or remote_url == '' then
    print('No git remote found')
    return
  end

  -- Convert git URL to https GitHub URL
  -- Handle both SSH and HTTPS formats
  local github_url = remote_url:gsub('git@github%.com:', 'https://github.com/')
  github_url = github_url:gsub('%.git$', '')

  -- Get current branch
  local branch = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(git_root) .. ' rev-parse --abbrev-ref HEAD')[1]

  -- Build full URL with line number
  local full_url = github_url .. '/blob/' .. branch .. '/' .. relative_path .. '#L' .. line_num

  vim.fn.setreg('+', full_url)
  print('Copied: ' .. full_url)
end, { noremap = true, silent = true, desc = 'Yank GitHub URL' })

-- Open git blame for entire file
vim.keymap.set('n', '<leader>ghB', ':Git blame<CR>', { noremap = true, silent = true, desc = 'Git blame file' })

-- Open PR for current line in browser (using pr.nvim plugin)
vim.keymap.set('n', '<leader>gpr', function()
  require('pr').view()
end, { noremap = true, silent = true, desc = 'Open PR for current line' })

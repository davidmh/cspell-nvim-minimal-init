local M = {}

function M.root(root)
  local f = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(f, ":p:h") .. "/" .. (root or "")
end

function M.setup()
  vim.loader.enable()
  vim.cmd([[set runtimepath=$VIMRUNTIME]])
  vim.opt.runtimepath:append(M.root())
  vim.opt.packpath = { M.root(".local/site") }
  vim.env.XDG_CONFIG_HOME = M.root(".local/config")
  vim.env.XDG_DATA_HOME = M.root(".local/data")
  vim.env.XDG_STATE_HOME = M.root(".local/state")
  vim.env.XDG_CACHE_HOME = M.root(".local/cache")
  local lazypath = vim.env.XDG_DATA_HOME .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    spec = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "neovim/nvim-lspconfig",
          "davidmh/cspell.nvim",
        },
        opts = function(_, opts)
          local cspell = require("cspell")
          local cspell_opts = {
            prefer_local = "node_modules/.bin",
          }
          opts.sources = vim.list_extend(opts.sources or {}, {
            cspell.diagnostics.with(cspell_opts),
            cspell.code_actions.with(cspell_opts),
          })
        end,
      },
    },
    defaults = {
      lazy = false,
      version = false,
    },
  })

  vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action, { desc = "code action" })
  vim.keymap.set("n", "<space>n", vim.diagnostic.goto_next, { desc = "next diagnostic" })
  vim.keymap.set("n", "<space>p", vim.diagnostic.goto_next, { desc = "previous diagnostic" })
  vim.schedule(function()
    vim.notify([[ <space>a -> code action | <space>n -> next diagnostic | <space>p -> previous diagnostic ]])
  end)
end

vim.o.swapfile = false
_G.__TEST = true

M.setup()

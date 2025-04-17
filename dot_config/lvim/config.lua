-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
-- ...
  { "almo7aya/neogruvbox.nvim" }
}

lvim.colorscheme = "neogruvbox"
lvim.guicursor = "i-ci-v:hor30"
lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "neoclip")
  -- any other extensions loading
end
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        print ">>> Set my custom cursor line color:)"
        vim.cmd 'hi CursorLine guifg=NONE guibg=#424141 ctermbg=NONE gui=NONE cterm=NONE'
    end,
})

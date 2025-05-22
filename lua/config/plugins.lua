local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false

if fn.empty(fn.glob(install_path)) > 0 then
  print("Packer not found, cloning...")
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
  packer_bootstrap = true
end

vim.cmd [[packadd packer.nvim]]  -- **Forzar carga packer**

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Yours plugins
  use 'alexandregv/norminette-vim'
  use { 'dracula/vim', as = 'dracula' }
  use 'sainnhe/everforest'
  use 'dense-analysis/ale'
  use 'vim-syntastic/syntastic'
  use 'preservim/nerdtree'
  use 'vim-airline/vim-airline'
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'

  if packer_bootstrap then
    require('packer').sync()
  end
end)


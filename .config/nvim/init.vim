call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'
Plug 'junegunn/vim-slash'
call plug#end()

syntax on
set ignorecase
set smartcase
set mouse=a
set noshowmode
set nowrap
set number
set showmatch
set splitbelow splitright
"set virtualedit=all
set wildmode=longest,list,full

let g:airline_theme='base16'
let g:airline_powerline_fonts=1
colorscheme codedark
set cursorline
set cursorcolumn
highlight CursorLine ctermbg=235 cterm=bold
highlight CursorLineNR ctermbg=235 cterm=bold
highlight CursorColumn ctermbg=235 cterm=bold

autocmd BufWritePre * %s/\s\+$//e
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

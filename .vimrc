call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'RyanMillerC/better-vim-tmux-resizer'
Plug 'morhetz/gruvbox'
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'

"{{ Git integration" ---> git commands within vim <---
Plug 'tpope/vim-fugitive'" ---> git changes on the gutter <---
Plug 'airblade/vim-gitgutter'" ---> nerdtree git changes <---
Plug 'Xuyuanp/nerdtree-git-plugin'
"}}






"{{ Autopairs" ---> closing XML tags <---
Plug 'alvan/vim-closetag'" ---> files on which to activate tags auto-closing <---
  let g:closetag_filenames = '*.html,*.xhtml,*.xml,*.vue,*.phtml,*.js,*.jsx,*.coffee,*.erb'" ---> closing braces and brackets <---
Plug 'jiangmiao/auto-pairs'
"}}

"{{ Configuring UltiSnipsPlug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
  let g:UltiSnipsExpandTrigger = "<tab>"
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

  "}}
call plug#end()

"Gruvbox theme settings
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='default'

"Enabling emmet for only html/css(C-y,)
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

"map CTRL-E to end-of-line (insert mode)
  imap <C-e> <esc>$i<right>
"  " " map CTRL-A to beginning-of-line (insert mode)
   imap <C-a> <esc>0i
"

"   " Open Nerd tree everytime
"   autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif


"Ctrl-t to toggle nerd tree
 nnoremap <C-t> :NERDTreeToggle<CR>

"nerd tree window size
let g:NERDTreeWinSize=20


"Better split bar
highlight VertSplit cterm=NONE

"Mapping esc to jj
inoremap jj <ESc>

" Leader - ( Spacebar )
let mapleader = " "

nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

"Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>

" double space to change buffers
nnoremap <leader><leader> <c-^>

" space + q  to quit without making any changes
" space + d  to quit after making changes
nnoremap <leader>x :xa<cr>
nnoremap <leader>q :qa!<cr>
nnoremap <leader>d :q!<cr>
nnoremap <leader>w :wa<cr>

" allows changing buffer without editing
set hidden

" autosave"
autocmd TextChanged,TextChangedI <buffer> silent write

" Save whenever switching windows or leaving vim. This is useful when running
" " the tests inside vim without having to save all files first.
 au FocusLost,WinLeave * :silent! wa

" Doesn't wrap the text
set linebreak

set nocompatible
set nu
set relativenumber
set numberwidth=4
syntax on

" no swap/backup files
set nobackup
set nowb
set noswapfile
set nowritebackup

" Shows incomplete command in the bottom
 set wildmenu
" " Sets auto indentation
 set ai 
 
" Indentation without hard tabs 
 set expandtab
set shiftwidth=2
 set softtabstop=2

 " don't keep search highlighted
 set nohlsearch
 " highlights as you search
 set incsearch

 " status bar colors
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan


" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
   \ 't'  : 'Terminal'
    \}

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %n\                                 " Buffer number
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
set statusline+=%0*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%=                                       " Right Side
"set statusline+=%2*\ %Y\                                 " FileType
"set statusline+=%3*│                                     " Separator
set statusline+=%0*\ \ %02v\                         " Colomn number
"set statusline+=%3*│                                     " Separator
set statusline+=%0*\ \ %02l/%L\ (%3p%%)\              " Line number / total lines, percentage of document

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e


set splitbelow splitright

" resize panes
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

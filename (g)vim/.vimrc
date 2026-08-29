source $VIMRUNTIME/vimrc_example.vim
cd D:/CP

"editor settings
set number
syntax on
set title
set nocursorline
set linespace=2
set nowrap
set cb=unnamed
"keybinds
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}
autocmd InsertLeave * set relativenumber
autocmd InsertEnter * set norelativenumber
nnoremap <F4> :set relativenumber!<CR>
inoremap <F4> <Esc>:set relativenumber!<CR>a
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

"windows keybinds
nnoremap <C-z> :u<CR>
inoremap <C-z> <Esc> :u<CR>a
nnoremap <C-a> ggvG<CR>
inoremap <C-a> <Esc> ggvG<CR>a
nnoremap <C-x> :yd<CR>
inoremap <C-x> <Esc> :yd<CR>a
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc> :w<CR>a

"tab & code format
set tabstop=4
set shiftwidth=4
set autoindent
set encoding=utf-8


"gui custom
if has("gui_running")
	set showtabline=2
    set guioptions-=t
    set guioptions-=T "remove toolbar
    set guioptions-=r "remove scrollbar
    set guioptions-=R "remove scrollbar
    set guioptions-=l "remove scrollbar
    set guioptions-=L "remove scrollbar
    set guifont=Fixedsys:h15
endif
"status bar custom
set laststatus=1


"back-up files & undo files problem
set nobackup
set nowritebackup
set undofile
set undodir=$USERPROFILE/.vim/undo//
"<F8>: run only
"<F9>: save, compile, run (c++, py)
"<F10>: compile only
autocmd FileType cpp nnoremap <buffer> <F9> :w<CR>:execute '!cd /d "' . expand('%:p:h') . '" && g++ -O2 -std=c++17 -Wall "' . expand('%:t') . '" -o "' . expand('%:t:r') . '.exe" && .\' . expand('%:t:r') . '.exe && echo.'<CR>
autocmd FileType python nnoremap <buffer> <F9> :w<CR>:execute '!cd /d "' . expand('%:p:h') . '" && python "' . expand('%:t') . '" && echo.'<CR>

filetype plugin on
filetype indent on

set expandtab
set smarttab
set autoindent
set smartindent
set softtabstop=4
set shiftwidth=4
set tabpagemax=40
set showtabline=2

set laststatus=2
set statusline=%<%F%h%m%r%h%w%y\ %=\ col:%3c%V\ ascii:%3b[0x%2B]\ pos:%6o\ line:%4l\/%L\ %P

set wildmode=longest,list,full

map <F3> :tabprev<cr>
map <F4> :tabnext<cr>
imap <F3> <esc>:tabprev<cr>a
imap <F4> <esc>:tabnext<cr>a
map <F5> <esc>:setlocal spell spelllang=en<CR>
map <F6> <esc>:setlocal spell spelllang=ru<CR>
map <F7> <esc>:setlocal nospell<CR>
imap <F5> <esc>:setlocal spell spelllang=en<CR>a
imap <F6> <esc>:setlocal spell spelllang=ru<CR>a
imap <F7> <esc>:setlocal nospell<CR>a
colorscheme koehler
highlight UglyLine ctermbg=Cyan
autocmd BufWinEnter * let w:m1=matchadd('UglyLine', '\%>80v.\+', -1)
autocmd BufWinEnter * let w:m2=matchadd('UglyLine', '\s\+$', -1)
autocmd FileType xml setlocal shiftwidth=2 softtabstop=2
autocmd FileType html setlocal shiftwidth=2 softtabstop=2
autocmd FileType xslt setlocal shiftwidth=2 softtabstop=2
autocmd FileType xsd setlocal shiftwidth=2 softtabstop=2


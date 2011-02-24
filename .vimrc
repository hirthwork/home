filetype plugin on
filetype indent on

set expandtab
set smarttab
set autoindent
set smartindent
set softtabstop=4
set shiftwidth=4
set foldlevel=2

set laststatus=2
set statusline=%<%F%h%m%r%h%w%y\ %=\ col:%3c%V\ ascii:%3b[0x%2B]\ pos:%6o\ line:%4l\/%L\ %P

map <F3> :bp!<cr>
map <F4> :bn!<cr>
imap <F3> <esc>:bp!<cr>a
imap <F4> <esc>:bn!<cr>a
map <F5> <esc>:setlocal spell spelllang=en<CR>
map <F6> <esc>:setlocal nospell<CR>
imap <F5> <esc>:setlocal spell spelllang=en<CR>a
imap <F6> <esc>:setlocal nospell<CR>a
colorscheme desert
highlight UglyLine ctermbg=Brown
autocmd BufWinEnter * let w:m1=matchadd('UglyLine', '\%>79v.\+', -1)
autocmd BufWinEnter * let w:m2=matchadd('UglyLine', '\s\+$', -1)
autocmd FileType xml setlocal shiftwidth=2 softtabstop=2
autocmd FileType html setlocal shiftwidth=2 softtabstop=2
autocmd FileType xslt setlocal shiftwidth=2 softtabstop=2
autocmd FileType xsd setlocal shiftwidth=2 softtabstop=2
autocmd BufReadPre * setlocal foldmethod=indent
autocmd BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif


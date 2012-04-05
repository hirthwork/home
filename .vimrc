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

set backspace=eol,start,indent

map <Insert> <Nop>
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
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
highlight StatusLine ctermfg=Gray ctermbg=Black
highlight TabLine cterm=bold ctermfg=Gray ctermbg=Black
highlight TabLineFill cterm=bold ctermfg=Gray ctermbg=Black
highlight TabLineSel ctermfg=Black ctermbg=Gray
highlight UglyLine ctermbg=Cyan
set textwidth=79

fun! <SID>is_pager_mode()
    let l:ppidc = ""
    try
        if filereadable("/lib/libc.so.6")
            let l:ppid = libcallnr("/lib/libc.so.6", "getppid", "")
        elseif filereadable("/lib/libc.so.0")
            let l:ppid = libcallnr("/lib/libc.so.0", "getppid", "")
        else
            let l:ppid = ""
        endif
        let l:ppidc = system("ps -p " . l:ppid . " -o comm=")
        let l:ppidc = substitute(l:ppidc, "\\n", "", "g")
    catch
    endtry
    return l:ppidc ==# "less.sh" ||
        \ l:ppidc ==# "vimpager" ||
        \ l:ppidc ==# "manpager.sh" ||
        \ l:ppidc ==# "vimmanpager"
endfun

function! TabExec(cmd)
  echo "Executing: '".substitute(a:cmd, '^!', '', 'g')."'..."
  tabnew
  silent! execute "read ".a:cmd
  set nomodified
endfunction
command! -nargs=+ -complete=command TabExec call TabExec(<q-args>)

let g:clang_complete_copen = 1
let g:clang_no_cache = 1
autocmd BufWinEnter,WinEnter * if !<SID>is_pager_mode() | let w:m1=matchadd('UglyLine', '\%>79v.\+', -1) | let w:m2=matchadd('UglyLine', '\s\+$') | endif
autocmd BufRead,BufNewFile *.proto setfiletype proto
autocmd BufRead,BufNewFile *.nw setfiletype plaintex
autocmd BufRead,BufNewFile AUTHORS setfiletype txt
autocmd BufRead,BufNewFile COPYING setfiletype txt
autocmd BufRead,BufNewFile INSTALL setfiletype txt
autocmd BufRead,BufNewFile README setfiletype txt
autocmd BufRead,BufNewFile TODO setfiletype txt
autocmd FileType html setlocal shiftwidth=2 softtabstop=2
autocmd FileType python setlocal shiftwidth=2 softtabstop=2
autocmd FileType xml setlocal shiftwidth=2 softtabstop=2
autocmd FileType xslt setlocal shiftwidth=2 softtabstop=2
autocmd FileType xsd setlocal shiftwidth=2 softtabstop=2
autocmd Filetype java setlocal completefunc=javacomplete#Complete


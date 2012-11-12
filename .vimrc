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

set incsearch

set wildmode=longest,list,full

set backspace=eol,start,indent

set langmap=№.\\,;#/?,ёйцукенгшщзхъфывапролджэячсмитьбю;`qwertyuiop[]asdfghjkl\;'zxcvbnm\\,.,ЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>

map <F6> <esc>:setlocal spell spelllang=en<CR>
map <F7> <esc>:setlocal spell spelllang=ru<CR>
map <F8> <esc>:setlocal nospell<CR>
imap <F6> <esc>:setlocal spell spelllang=en<CR>a
imap <F7> <esc>:setlocal spell spelllang=ru<CR>a
imap <F8> <esc>:setlocal nospell<CR>a
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
highlight TabLine ctermfg=Gray ctermbg=Black cterm=none
highlight TabLineFill ctermfg=Gray ctermbg=Black cterm=none
highlight TabLineSel ctermfg=Green ctermbg=Black cterm=bold
highlight TabNumber ctermfg=Black ctermbg=Gray
highlight UglyLine ctermfg=Black ctermbg=Cyan
highlight Pmenu ctermfg=Gray ctermbg=Blue
highlight PmenuSel ctermfg=Blue ctermbg=Gray
highlight PmenuSbar ctermbg=Cyan

set textwidth=79

set laststatus=2
set statusline=%<%F%h%m%r%h%w%y%=\ ascii:%3b[0x%2B]\ pos:%6o\ line:%4l:%c%V\/%L

function! <SID>is_pager_mode()
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
let g:clang_auto_select = 1
let g:clang_complete_auto = 0

if exists("+showtabline")
    function ParsedTabnames()
        let tabnames = []
        let i = 1
        let tabcount = tabpagenr('$')
        while i <= tabcount
            let tabname = fnamemodify(
                        \ bufname(tabpagebuflist(i)[tabpagewinnr(i) - 1]),
                        \ ':p:~:.')
            if tabname == ''
                let tabname = '[No Name]'
            endif
            call add(tabnames, reverse(split(tabname, '/')))
            let i = i + 1
        endwhile
        return tabnames
    endfunction

    function MyTabLine()
        let tabnames = ParsedTabnames()
        let tabcount = tabpagenr('$')
        let s = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabcount
            let m = 0 "modified buffers flag
            for b in tabpagebuflist(i)
                if getbufvar(b, '&modified')
                    let m = 1
                endif
            endfor
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= '%#TabNumber#'
            let s .= i
            if m == 1
                let s .= '+'
            endif
            let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let file = copy(tabnames[i - 1])
            let maxhit = 0
            for current in tabnames
                if current != file
                    let hit = 0
                    while get(current, hit) == get(file, hit)
                        let hit = hit + 1
                    endwhile
                    if hit > maxhit
                        let maxhit = hit
                    endif
                endif
            endfor
            let s .= join(reverse(remove(file, 0, maxhit)), '/')
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set tabline=%!MyTabLine()
endif

autocmd BufWinEnter,WinEnter * if bufname('') == '' || <SID>is_pager_mode() | call clearmatches() | else | let w:m1=matchadd('UglyLine', '\%>79v.\+', -1) | let w:m2=matchadd('UglyLine', '\s\+$') | endif
autocmd BufRead,BufNewFile *.nw setfiletype plaintex
autocmd BufRead,BufNewFile *.proto setfiletype proto
autocmd BufRead,BufNewFile *.rl setfiletype ragel
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
autocmd Filetype java setlocal completefunc=javacomplete#Complete | set makeprg=ant | set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#


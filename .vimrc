filetype plugin on
filetype indent on

set binary
set expandtab
set smarttab
set autoindent
set smartindent
set softtabstop=4
set shiftwidth=4
set tabpagemax=40
set showtabline=2

set incsearch
set hlsearch

set splitbelow
set splitright

set wildmode=longest,list,full

set backspace=eol,start,indent

set langmap=№.\\,;#/?,ёйцукенгшщзхъфывапролджэячсмитьбю;`qwertyuiop[]asdfghjkl\;'zxcvbnm\\,.,ЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>

set switchbuf=usetab,newtab

set kp=w3mman

set showcmd

map <F6> <esc>:setlocal spell spelllang=en<CR>
map <F7> <esc>:setlocal spell spelllang=ru<CR>
map <F8> <esc>:setlocal nospell<CR>
imap <F6> <esc>:setlocal spell spelllang=en<CR>a
imap <F7> <esc>:setlocal spell spelllang=ru<CR>a
imap <F8> <esc>:setlocal nospell<CR>a
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

highlight TabLine ctermfg=Gray ctermbg=none cterm=none
highlight TabLineFill ctermfg=Gray ctermbg=none cterm=none
highlight TabLineSel ctermfg=Green ctermbg=none cterm=bold
highlight TabNumber ctermfg=Black ctermbg=Gray

highlight ColorColumn ctermbg=Blue
highlight HighlightLine ctermfg=Black ctermbg=Green

highlight Pmenu ctermfg=Gray ctermbg=Blue
highlight PmenuSel ctermfg=Blue ctermbg=Gray
highlight PmenuSbar ctermbg=Cyan

highlight DiffAdd cterm=bold ctermbg=Green
highlight DiffChange cterm=bold ctermbg=none
highlight DiffDelete cterm=bold ctermbg=Red
highlight DiffText cterm=bold ctermbg=Blue

set textwidth=79
set colorcolumn=80

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
                    while get(current, hit, '') == get(file, hit, '')
                        let hit = hit + 1
                    endwhile
                    if hit > maxhit
                        let maxhit = hit
                    endif
                endif
            endfor
            let name = join(reverse(file), '/')
            if maxhit < len(file)
                let name = join(reverse(remove(reverse(file), 0, maxhit)), '/')
            endif
            let s .= name
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        return s
    endfunction
    set tabline=%!MyTabLine()
endif

command! -complete=file -nargs=+ Etabs call s:ETW(<f-args>)

function s:ETW(...)
    let path = split(expand('%@:p:h') , '/')
    let f = a:000[0]
    let i = len(path)
    while i >= 0
        if i == 0
            let folder = ''
        else
            let folder = join(path[:(i - 1)], '/')
        endif
        let files = glob('`find ' . folder . ' -type f -name ' . f . '`')
        if files != ''
            for f2 in split(files, '\n')
                execute 'tabnew ' . escape(f2, '\ "')
            endfor
            return
        endif
        let i = i - 1
    endwhile
endfunction

let g:highlights={}

function s:HighlightLine()
    let lineno = line(".")
    if has_key(g:highlights, lineno)
        call matchdelete(get(g:highlights, lineno))
        call remove(g:highlights, lineno)
    else
        let l:m = matchaddpos("HighlightLine", [lineno])
        let g:highlights[lineno] = l:m
    endif
endfunction
command HighlightLine call s:HighlightLine()

function s:HighlightLineClear()
    for k in keys(g:highlights)
        call matchdelete(get(g:highlights, k))
        call remove(g:highlights, k)
    endfor
endfunction
command HighlightLineClear call s:HighlightLineClear()

autocmd BufWinEnter,WinEnter * if bufname('') == '' || <SID>is_pager_mode() | call clearmatches() | else | let w:m1=matchadd('ErrorMsg', '\s\+$') | let w:m2=matchadd('WarningMsg', '\%>' . &cc . 'v.\+', -1) | endif
autocmd BufRead,BufNewFile *.nw setfiletype plaintex
autocmd BufRead,BufNewFile *.proto setfiletype proto
autocmd BufRead,BufNewFile *.rl setfiletype ragel | setlocal syntax=ragel
autocmd BufRead,BufNewFile *.rl6 setfiletype ragel | setlocal syntax=ragel
autocmd BufRead,BufNewFile *.lex setfiletype jflex | setlocal syntax=jflex
autocmd BufRead,BufNewFile Dockerfile setfiletype dockerfile | setlocal syntax=dockerfile
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
autocmd FileType proto setlocal shiftwidth=2 softtabstop=2
autocmd FileType make setlocal iskeyword+=- | setlocal iskeyword+=.
autocmd Filetype java setlocal kp=~/javaman makeprg=ant efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#|
    map <C-j> <esc>:Etabs <cword>.java<CR>|
    imap <C-j> <esc>:Etabs <cword>.java<CR>|
    map <C-f> <esc>:Etabs <cfile><CR>|
    imap <C-f> <esc>:Etabs <cfile><CR>|
    map <F4> <esc>:HighlightLine<CR>|
    imap <F4> <esc>:HighlightLine<CR>|
    map <F2> <esc>:HighlightLineClear<CR>|
    imap <F2> <esc>:HighlightLineClear<CR>

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['white',       'DarkOrchid3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ['blue',        'DarkOrchid3'],
    \ ['green',       'DarkOrchid3'],
    \ ['yellow',      'DarkOrchid3'],
    \ ['magenta',     'DarkOrchid3'],
    \ ['cyan',        'DarkOrchid3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['brown',       'firebrick3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ]

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadChevrons


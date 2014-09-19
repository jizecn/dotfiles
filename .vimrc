" Don't run in vi compatibility mode
set nocompatible

filetype off

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Vundle
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" Vundle manages vim plugins. This is required! All bundles refer to some repo
" on github.
Bundle 'gmarik/vundle'

" Solarized theme
Bundle 'altercation/vim-colors-solarized'

" The Command-T plug-in provides an extremely fast, intuitive mechanism for
" opening files with a minimal number of keystrokes.
Bundle 'wincent/Command-T'

" YouCompleteMe is a fast, as-you-type, fuzzy-search code completion engine.
Bundle 'Valloric/YouCompleteMe'

" Surround.vim is all about surroundings: parentheses, brackets, quotes, XML
" tags, and more. The plugin provides mappings to easily delete, change and
" add such surroundings in pairs.
Bundle 'tpope/vim-surround'

" Generates a doxygen comment skeleton for a C, C++ or Python function or
" class (Bound to F6)
Bundle 'DoxygenToolkit.vim'

" This Vim plugin will help switching between companion files
Bundle 'derekwyatt/vim-fswitch'

" Easily interact with tmux from vim.
Bundle 'benmills/vimux'

" Resolve conflicts during three-way merges
Bundle 'sjl/splice.vim'

" Move camel-wise
Bundle 'bkad/CamelCaseMotion'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Behavior
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlighting for > 80 characters

au BufLeave * set nocursorline
au BufEnter * silent! lcd %:p:h set cursorline
au BufEnter *.C,*.H,*.c,*.cpp,*.h,*.hpp silent! lcd %:p:h
\ | highlight BadWhite ctermbg=red ctermfg=white guibg=#592929
\ | match BadWhite '\(^\s\+[\n\r]\)\|\(\%>80v.\+\)\|\(\s\+\_$\)\|\( \+\t\)'

" Auto-switch to each buffer's current working directory
au BufEnter * set autochdir
" Smarter tab completion in command line
set wildmenu wildmode=list:longest

" Share clipboards between instances of vim
au BufEnter * set clipboard+=unnamed

" C & C Specific settings
set path+=/home/zeji/work/*/include
set path+=/usr/local/include


" Show line numbers
set number
highlight LineNr ctermfg=233

" Indentation

" set noet sts=0 sw=8 ts=2
" set cindent
" set cinoptions=(0,u0,U0

" set tab width to 8
au BufEnter *.C,*.H,*.c,*.cpp,*.h,*.hpp set softtabstop=8 shiftwidth=8 tabstop=8 noexpandtab smartindent autoindent cindent cinoptions=(0,u0,U0
au BufEnter *.m,*.xml,*.scm-command,*.scm-config,*.scm-data,*.scm-event,*.sensor,*.device,*.html,*.htm,*.css set softtabstop=2 shiftwidth=2 expandtab smartindent autoindent cindent cinoptions=(0,u0,U0

" Automatically update copyright notice with current year
autocmd BufWritePre *.C,*.H
  \ if &modified |
  \   exe "g#\Copyright (c) \\(".strftime("%Y")."\\)\\@![0-9]\\{4\\}\\(-".strftime("%Y")."\\)\\@!#s#\\([0-9]\\{4\\}\\)\\(-[0-9]\\{4\\}\\)\\?#\\1-".strftime("%Y") |
  \ endif

"""""""""""""
" Tab names "
"""""""""""""

"Rename tabs to show tab# and # of viewports
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= (i== t ? '%#TabNumSel#' : '%#TabNum#')
            let s .= i

            let s .= ' %*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif

	    if getbufvar(bufnr, "&modified")
                let s .= '+'
	    endif

            let s .= file
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
endif

" set tabstop=2

syntax enable
set background=dark
colorscheme koehler 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Plugin settings
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Doxygen:
let g:DoxygenToolkit_commentType = "C++"
let g:DoxygenToolkit_briefTag_pre="\\brief "
let g:DoxygenToolkit_paramTag_pre="\\param "
let g:DoxygenToolkit_returnTag="\\return "
let g:DoxygenToolkit_blockFooter=""
let g:DoxygenToolkit_authorName="Ze Ji"

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '/home/zeji/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_filetype_whitelist = {
\ 'cpp' : 1,
\ 'h' : 1,
\ 'C' : 1,
\ 'H' : 1,
\ 'pro' : 1,
\ 'qrc' : 1,
\}
" Disable the YCM preview window
set completeopt-=preview
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Bindings
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Function keys

" Eat the help hotkey
map <F1> <Nop>
" Show header/source (plugin)
map <F4> :FSSplitRight<CR>
" Create doxygen comment (plugin)
map <F6> :Dox<CR>
" Compile in a tmux pane (plugin)
map <F7> :wa <CR> :VimuxInterruptRunner <CR> :call VimuxRunCommand("make install -j8 && make install-doxygen-html")<CR>
" Compile and run scm-ui in a tmux pane (plugin)
" map <F8> :wa <CR> :VimuxInterruptRunner <CR> :call VimuxRunCommand("qmake && make install -j8 && ./bin/coord-convert")<CR>

" Easier movement between windows
noremap <C-H> <C-W>h
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-L> <C-W>l

" This allows for change paste motion cp{motion}. It replaces the motion text
" with whatever is in the default buffer without overwriting the default
" buffer.
nmap <silent> cp :set opfunc=ChangePaste<CR>g@

function! ChangePaste(type, ...)
silent exe "normal! `[v`]\"_c"
silent exe "normal! p"
endfunction

" Map W to w to forgive typos
:ca WQ wq
:ca Wq wq
:ca W w
:ca Q q

" Automatically append closing parentheses
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"

execute pathogen#infect()
syntax on


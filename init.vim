#!/bin/sh
"Lines that start with quotation marks are comments."
"The first line tricks the editor into using shell script syntax highlighting."

"Includes for modeful vim."

"Load the statusline at the bottom."
"Requires a Nerd Font (https://www.nerdfonts.com/) and Unicode support."
runtime statusline_nerdfont.vimrc

"You may comment the above line and uncomment the following to load"
"  a version of the statusline that just uses ASCII."
"runtime statusline_ascii.vimrc"

"Load the colorscheme."
runtime colorscheme.vimrc

"Load the basic options."
runtime options_basic.vimrc

" Load the infoline at the top (requires Nerd Font)
runtime infoline_nerdfont.vimrc

" Load keybindings "
runtime runtime keybinds.vimrc

" Load the modeless plugin logic" 
runtime plugin/modeless.vim

" Always enter insert mode when starting Vim" 
autocmd VimEnter * startinsert

"Allow mouse clicks"
set mouse=a

"make cursor a line"
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  au InsertEnter,InsertChange *
\ if v:insertmode == 'i' | 
\   silent execute '!echo -ne "\e[6 q"' | redraw! |
\ elseif v:insertmode == 'r' |
\   silent execute '!echo -ne "\e[4 q"' | redraw! |
\ endif
au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

"wrap text in windows"
set wrap
set linebreak        " Don’t split words in the middle" 

"number lines"
set number

" === Load gruvbox theme ===
set background=dark      " or light
colorscheme gruvbox

"recognise typst"
autocmd BufNewFile,BufRead *.typ setfiletype typst

"let cursor go to next/prev line with L/R arrow keys"
set whichwrap+=<,>,[,]

"Run my Lua config file"
lua require('config')

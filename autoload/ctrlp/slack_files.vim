" =============================================================================
" File:          autoload/ctrlp/slack_files.vim
" Description:   CtrlP extension for Slack Files.
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['slack_files']
"
" Where 'slack_files' is the name of the file 'slack_files.vim'
"
" For multiple extensions:
"
"     let g:ctrlp_extensions = [
"         \ 'my_extension',
"         \ 'my_other_extension',
"         \ ]

" Load guard
if ( exists('g:loaded_ctrlp_slack_files') && (! exists('g:slack_files_dev') ) )
  \ || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_slack_files = 1


" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
call add(g:ctrlp_ext_vars, {
  \ 'init': 'ctrlp#slack_files#init()',
  \ 'accept': 'ctrlp#slack_files#accept',
  \ 'wipe': 'ctrlp#slack_files#wipe',
  \ 'lname': 'slack_files',
  \ 'sname': 'slack',
  \ 'type': 'line',
  \ 'enter': 'ctrlp#slack_files#enter()',
  \ 'exit': 'ctrlp#slack_files#exit()',
  \ 'opts': 'ctrlp#slack_files#opts()',
  \ 'sort': 0,
  \ 'specinput': 0,
  \ 'opmul': 1,
  \ })


" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#slack_files#init() "{{{
  let files = slack_files#api#files#list().files
  call sort(files, 'slack_files#util#sort_slack_files')

  " make slack file list
  let list = []
  for file in files
    let title = file.title
    let filetype = file.filetype
    let url = file.url_private
    let id = file.id
    call add(list, printf("%s\t<%s>\t%s\t%s", title, filetype, url, id))
  endfor

  " highlight
  call ctrlp#hicheck('CtrlPSlackFilesFilename', 'Identifier')
  call ctrlp#hicheck('CtrlPSlackFilesFiletype', 'Special')
  call ctrlp#hicheck('CtrlPSlackFilesURLAndID', 'Comment')
  syn match CtrlPSlackFilesFilename ' [^\t]\+'
  syn match CtrlPSlackFilesFiletype '<.\+>'
  syn match CtrlPSlackFilesURLAndID 'https:\/\/.\+'

  return list
endfunction "}}}


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#slack_files#accept(mode, str) "{{{
  call ctrlp#exit()

  let opener = {
  \ 'e': 'edit',
  \ 'v': 'vsplit',
  \ 'h': 'split',
  \ 't': 'tabnew',
  \}
  let strs = split(a:str, '\t')
  let title = get(strs, 0)
  let filetype = substitute(get(strs, 1), '[<>]', '', 'g')
  let url = get(strs, 2)
  let id = get(strs, 3)
  call slack_files#open(url, id, filetype, title, {'opener': opener[a:mode]})
endfunction "}}}


" The action to wipe on the selected string
"
" Arguments:
"  a:entries   List of the selected string
"
function! ctrlp#slack_files#wipe(entries) "{{{
  for item in a:entries
    let strs = split(item, '\t')
    let id = get(strs, 3)
    call slack_files#api#files#delete(id)
  endfor
  return ctrlp#slack_files#init()
endfunction "}}}


" (optional) Do something before enterting ctrlp
function! ctrlp#slack_files#enter() "{{{
endfunction "}}}


" (optional) Do something after exiting ctrlp
function! ctrlp#slack_files#exit() "{{{
endfunction "}}}


" (optional) Set or check for user options specific to this extension
function! ctrlp#slack_files#opts() "{{{
endfunction "}}}


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#slack_files#id() "{{{
  return s:id
endfunction "}}}


" Create a command to directly call the new search type
"
" Put this in vimrc or plugin/slack_files.vim
" command! CtrlPSlackFiles call ctrlp#init(ctrlp#slack_files#id())


" vim:nofen:fdl=0:ts=2:sw=2:sts=2


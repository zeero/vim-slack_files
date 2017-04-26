" =============================================================================
" File:          autoload/slack_files/autocmd.vim
" Description:   Functions called from Autocommands.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" open slack buffer
" Arguments: [bufname] slack buffer name
function! slack_files#autocmd#onBufReadCmd(bufname) abort "{{{
  let info = slack_files#util#bufname2info(a:bufname)
  call slack_files#common#open(info.url, info.id, info.filetype, info.title)
endfunction "}}}

" upload slack buffer
" Arguments: [bufname] slack buffer name
function! slack_files#autocmd#onBufWriteCmd(bufname) abort "{{{
  " check
  if ! slack_files#util#is_slack_buffer(a:bufname)
    echohl WarningMsg
    echo 'ERROR: this buffer is not slack buffer'
    echohl None
    return
  endif

  let info = slack_files#util#bufname2info(a:bufname)
  let filename = substitute(info.url, '.*\/', '', '')
  let contents = getline('0', '$')
  let config = {'title': info.title, 'filetype': info.filetype}
  let res = slack_files#common#write(filename, contents, config)

  " delete old file
  return slack_files#api#files#delete(info.id)
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


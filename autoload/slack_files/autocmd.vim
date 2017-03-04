" =============================================================================
" File:          autoload/slack_files/autocmd.vim
" Description:   Functions called from Autocommands.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


function! slack_files#autocmd#onBufWriteCmd() "{{{
  let bufname = expand('%')
  
  " check
  if ! slack_files#util#is_slack_buffer(bufname)
    echohl WarningMsg
    echo 'ERROR: this buffer is not slack buffer'
    echohl None
    return
  endif

  let info = slack_files#util#bufname2info(bufname)
  let filename = substitute(info.url, '.*\/', '', '')
  let contents = getline('0', '$')
  let config = {'title': info.title, 'filetype': info.filetype}
  let res = slack_files#write(filename, contents, config)

  " delete old file
  call slack_files#api#files#delete(info.id)
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo

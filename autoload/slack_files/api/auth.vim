" =============================================================================
" File:          autoload/slack_files/api/auth.vim
" Description:   Functions for Slack Web API - auth
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" auth.test
" Arguments: [token] Slack Web API token String
function! slack_files#api#auth#test(token) "{{{
  if empty(a:token)
    return 0
  endif

  try
    call slack_files#api#helper#post('auth.test', {'token': a:token})
  catch
    return 0
  endtry
  return 1
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


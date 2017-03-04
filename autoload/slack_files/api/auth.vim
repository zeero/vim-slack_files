" =============================================================================
" File:          autoload/slack_files/api/auth.vim
" Description:   Functions for Slack Web API - auth
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" auth.test
" Arguments: [token] Slack Web API token String
function! slack_files#api#auth#test(token) abort "{{{
  if empty(a:token)
    throw 'slack_files: token is empty'
  endif

  try
    call slack_files#api#helper#post('auth.test', {'token': a:token})
  catch
    echomsg v:exception
    throw 'slack_files: invalid token'
  endtry
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


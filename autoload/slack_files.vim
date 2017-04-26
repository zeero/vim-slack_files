" =============================================================================
" File:          autoload/slack_files.vim
" Description:   Interface Functions
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


function! slack_files#list_types() "{{{
  return get(g:, 'slack_files#list_types', 'snippets')
endfunction "}}}

function! slack_files#token_file() "{{{
  return get(g:, 'slack_files#token_file', $HOME . '/.cache/vim-slack_files/token')
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


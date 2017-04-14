" =============================================================================
" File:          autoload/slack_files/buffer.vim
" Description:   Utility functions about buffer
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Vital
let s:V = vital#slack_files#new()
let s:Buffer = s:V.import('Vim.Buffer')


" Functions

" open buffer
" Arguments: [bufname]  buffer name
" Arguments: [opener]   buffer opener
" Arguments: [contents] List of file content lines
function! slack_files#buffer#open(bufname, opener, contents) "{{{
  call s:Buffer.open(a:bufname, a:opener)
  set buftype=acwrite
  call call(s:Buffer.edit_content, [a:contents], s:Buffer)
  doautocmd BufReadPost
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


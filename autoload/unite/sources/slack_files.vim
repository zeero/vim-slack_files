" =============================================================================
" File:          autoload/unite/sources/slack_files.vim
" Description:   Unite interface for slack_files
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


function! unite#sources#slack_files#gather_candidates(args, context) dict "{{{
  let files = slack_files#api#files#list().files
  call sort(files, 'slack_files#util#sort_slack_files')
  return map(files, '{
  \   "word": v:val.title,
  \   "source": "slack_files",
  \   "kind": "file",
  \   "action__path": slack_files#util#info2bufname(v:val.url_private, v:val.id, v:val.filetype, v:val.title),
  \}')
endfunction "}}}

function! unite#sources#slack_files#define() "{{{
  return {
  \ 'name': 'slack_files',
  \ 'gather_candidates': function('unite#sources#slack_files#gather_candidates'),
  \}
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


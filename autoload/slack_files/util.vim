" =============================================================================
" File:          autoload/slack_files/util.vim
" Description:   Utility functions.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Vital
let s:V = vital#slack_files#new()
let s:List = s:V.import('Data.List')

" Const
let s:PREFIX_BUFNAME = 'vimslackfiles://'
let s:PREFIX_URL = 'https://'

" convert file info to slack buffer name
" Arguments: [url]      slack file url
" Arguments: [id]       slack file ID
" Arguments: [filetype] a file type identifier
" Arguments: [title]    title of file
" Return:    slack buffer name (vimslackfiles://${url_path}/${id}/${filetype}/${buffer_title})
function! slack_files#util#info2bufname(url, id, filetype, title) "{{{
  return printf('%s/%s/%s/%s',
               \ substitute(a:url, s:PREFIX_URL, s:PREFIX_BUFNAME, ''),
               \ a:id,
               \ a:filetype,
               \ a:title
               \)
endfunction "}}}

" convert slack buffer name to file info Dictionary
" Arguments: [bufname] slack buffer name (vimslackfiles://${url_path}/${id}/${filetype}/${buffer_title})
" Return:    Dictionary
"              {
"                'url':      slack file url,
"                'id':       slack file ID,
"                'filetype': a file type identifier,
"                'title':    title of file,
"              }
function! slack_files#util#bufname2info(bufname) "{{{
  let list = split(a:bufname, '/')
  let title = s:List.pop(list)
  let filetype = s:List.pop(list)
  let id = s:List.pop(list)
  let url = substitute(join(list, '/'), s:PREFIX_BUFNAME, s:PREFIX_URL, '')
  return {'url': url, 'id': id, 'filetype': filetype, 'title': title}
endfunction "}}}

" check slack buffer
" Arguments: [bufname] buffer name
" Return:    is slack buffer name or not
function! slack_files#util#is_slack_buffer(bufname) "{{{
  if match(a:bufname, s:PREFIX_BUFNAME) == 0
    return 1
  endif
  return 0
endfunction "}}}

" get slack buffer prefix
" Return: slack buffer prefix
function! slack_files#util#prefix_bufname() "{{{
  return s:PREFIX_BUFNAME
endfunction "}}}

" sort file list by update time desc
function! slack_files#util#sort_slack_files(i1, i2) "{{{
  let time1 = str2nr(a:i1.timestamp)
  let time2 = str2nr(a:i2.timestamp)
  return time1 == time2 ? 0 : time1 < time2 ? 1 : -1
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


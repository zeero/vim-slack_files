" =============================================================================
" File:          autoload/slack_files/api/files.vim
" Description:   Functions for Slack Web API - files
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" files.upload
" Arguments: [filename] file name
" Arguments: [contents] List of file content lines
" Arguments: [...]      config Dictionary
"                         {
"                           'title':    title of file,
"                           'filetype': a file type identifier,
"                           'comment':  initial comment to add to file,
"                           'channels': comma-separated list of channel names or IDs where the file will be shared,
"                         }
" Return:    response Dictionary
function! slack_files#api#files#upload(filename, contents, ...) abort "{{{
  let config = get(a:000, 0, {})
  let title = get(config, 'title')
  let filetype = get(config, 'filetype')
  let comment = get(config, 'comment')
  let channels = get(config, 'channels')

  let data = {}
  let data.filename = a:filename
  let data.content = join(a:contents, "\n")
  if title isnot 0
    let data.title = title
  endif
  if filetype isnot 0
    let data.filetype = filetype
  endif
  if comment isnot 0
    let data.initial_comment = comment
  endif
  if channels isnot 0
    let data.channels = channels
  endif

  return slack_files#api#helper#post('files.upload', data)
endfunction "}}}

" files.list
" Return: response Dictionary
function! slack_files#api#files#list() abort "{{{
  return slack_files#api#helper#post('files.list', {'types': g:slack_files#list_types})
endfunction "}}}

" files.delete
" Arguments: [id] slack file ID
" Return: response Dictionary
function! slack_files#api#files#delete(id) abort "{{{
  return slack_files#api#helper#post('files.delete', {'file': a:id})
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


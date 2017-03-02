" =============================================================================
" File:          autoload/slack_files.vim
" Description:   Vim plugin for Slack Files.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Vital
let s:V = vital#slack_files#new()
let s:HTTP = s:V.import('Web.HTTP')
let s:JSON = s:V.import('Web.JSON')
let s:Buffer = s:V.import('Vim.Buffer')

" Const
let s:SLACK_API_DOMAIN = 'https://slack.com/api'
let s:TOKEN_FILE = g:slack_files_token_dir . '/token'


" Functions

" get file list
" Return: List with slack file Dictionary
function! slack_files#list() abort "{{{
  let req = {}
  let req.url = s:SLACK_API_DOMAIN . '/files.list'
  let req.method = 'post'
  let data = {}
  let data.token = slack_files#get_token()
  let data.types = g:slack_files_list_types
  let req.data = s:HTTP.encodeURI(data)

  let res = s:parse_response(s:HTTP.request(req))

  return res.files
endfunction "}}}

" open slack buffer
" Arguments: [url]      slack file url
" Arguments: [id]       slack file ID
" Arguments: [filetype] a file type identifier
" Arguments: [title]    title of file
" Arguments: [...]      config Dictionary, default values are {'opener': 'edit'}
function! slack_files#open(url, id, filetype, title, ...) abort "{{{
  let config = get(a:000, 0, {})
  let opener = get(config, 'opener', 'edit')

  " check
  " TODO: it cant handle files incluing slash in title
  if match(a:title, '\/') != -1
    echohl WarningMsg
    echo printf('ERROR: this plugin cant handle files including slash in title (title=%s)', a:title)
    echohl None
    return
  endif

  " open new buffer
  let bufname = slack_files#util#info2bufname(a:url, a:id, a:filetype, a:title)
  call s:Buffer.open(bufname, opener)
  set buftype=acwrite
  call call(s:Buffer.edit_content, [slack_files#read(a:url)], s:Buffer)
endfunction "}}}

" download slack file & return contents
" Arguments: [url] slack file url_private
" Return:    lines List of slack file content
function! slack_files#read(url) abort "{{{
  let req = {}
  let req.url = a:url
  let req.method = 'get'
  let req.headers = {}
  let req.headers.Authorization = printf('Bearer %s', slack_files#get_token())

  let res = s:HTTP.request(req)
  call s:check_http_status(res.status)
  return split(res.content, '\r\?\n')
endfunction "}}}

" upload slack file
" Arguments: [filename] file name
" Arguments: [contents] List of file content lines
" Arguments: [...]      config Dictionary
"                         {
"                           'title':    title of file,
"                           'filetype': a file type identifier,
"                           'comment':  initial comment to add to file,
"                           'channels': comma-separated list of channel names or IDs where the file will be shared,
"                         }
function! slack_files#write(filename, contents, ...) abort "{{{
  let config = get(a:000, 0, {})

  " upload
  let res = slack_files#upload(a:filename, a:contents, config)

  " replace buffer
  let new_url = res.file.url_private
  let new_id = res.file.id
  let new_filetype = res.file.filetype
  let new_title = res.file.title
  let new_bufname = slack_files#util#info2bufname(new_url, new_id, new_filetype, new_title)
  setlocal nomodified
  call s:Buffer.open(new_bufname, 'edit')
  set buftype=acwrite
  call call(s:Buffer.edit_content, [a:contents], s:Buffer)
  doautocmd BufReadPost
endfunction "}}}

" upload file
" Arguments: [filename] file name
" Arguments: [contents] List of file content lines
" Arguments: [...]      config Dictionary
"                         {
"                           'title':    title of file,
"                           'filetype': a file type identifier,
"                           'comment':  initial comment to add to file,
"                           'channels': comma-separated list of channel names or IDs where the file will be shared,
"                         }
" Return:    file.upload API response Dictionary
function! slack_files#upload(filename, contents, ...) "{{{
  let config = get(a:000, 0, {})
  let title = get(config, 'title')
  let filetype = get(config, 'filetype')
  let comment = get(config, 'comment')
  let channels = get(config, 'channels')

  let req = {}
  let req.url = s:SLACK_API_DOMAIN . '/files.upload'
  let req.method = 'post'
  let data = {}
  let data.token = slack_files#get_token()
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
  let req.data = s:HTTP.encodeURI(data)

  return s:parse_response(s:HTTP.request(req))
endfunction "}}}

" delete slack file
" Arguments: [id] slack file ID
function! slack_files#delete(id) abort "{{{
  let req = {}
  let req.url = s:SLACK_API_DOMAIN . '/files.delete'
  let req.method = 'post'
  let data = {}
  let data.token = slack_files#get_token()
  let data.file = a:id
  let req.data = s:HTTP.encodeURI(data)

  call s:parse_response(s:HTTP.request(req))
endfunction "}}}

" create slack file from buffer
function! slack_files#create() abort "{{{
endfunction "}}}

" get token
" Return: Slack API token String
function! slack_files#get_token() abort "{{{
  if filereadable(s:TOKEN_FILE)
    for line in readfile(s:TOKEN_FILE)
      return line
    endfor
    throw 'ERROR: token file is empty'
  else
    let token = input('Slack API Token: ')
    if slack_files#api#auth#test(token)
      if ! isdirectory(g:slack_files_token_dir)
        call mkdir(g:slack_files_token_dir, 'p')
      endif
      call writefile([token], s:TOKEN_FILE)
      return token
    else
      throw 'ERROR: invalid token'
    endif
  endif
endfunction "}}}


" Private Functions

" check http status
function! s:check_http_status(status) "{{{
  if a:status != '200'
    throw 'ERROR: Slack API network error'
  endif
endfunction "}}}

" parse Slack API response
" Arguments: [res] Web.HTTP response
" Return:    Web.HTTP content
function! s:parse_response(res) "{{{
  call s:check_http_status(a:res.status)

  let content = s:JSON.decode(a:res.content)
  if ! content.ok
    echomsg a:res.content
    throw 'ERROR: Slack API error'
  endif
  return content
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


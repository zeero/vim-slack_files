" =============================================================================
" File:          autoload/slack_files.vim
" Description:   Main Functions
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Vital
let s:V = vital#slack_files#new()
let s:Buffer = s:V.import('Vim.Buffer')

" Const
let s:SLACK_API_DOMAIN = 'https://slack.com/api'
let s:TOKEN_FILE = g:slack_files_token_dir . '/token'


" Functions

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
  let contents = split(slack_files#api#helper#get(a:url), '\r\?\n')
  call call(s:Buffer.edit_content, [contents], s:Buffer)
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
  let res = slack_files#api#files#upload(a:filename, a:contents, config)

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

" get token
" Return: Slack API token String
function! slack_files#get_token() abort "{{{
  if filereadable(s:TOKEN_FILE)
    for line in readfile(s:TOKEN_FILE)
      return line
    endfor
    throw 'slack_files: token file is empty'
  else
    let token = input('Slack API Token: ')
    call slack_files#api#auth#test(token)
    if ! isdirectory(g:slack_files_token_dir)
      call mkdir(g:slack_files_token_dir, 'p')
    endif
    call writefile([token], s:TOKEN_FILE)
    return token
  endif
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo


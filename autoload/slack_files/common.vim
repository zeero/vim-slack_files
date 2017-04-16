" =============================================================================
" File:          autoload/slack_files/common.vim
" Description:   Common Functions
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Functions

" open slack buffer
" Arguments: [url]      slack file url
" Arguments: [id]       slack file ID
" Arguments: [filetype] a file type identifier
" Arguments: [title]    title of file
" Arguments: [...]      config Dictionary, default values are {'opener': 'edit'}
function! slack_files#common#open(url, id, filetype, title, ...) abort "{{{
  let config = get(a:000, 0, {})
  let opener = get(config, 'opener', 'edit')

  " check
  if match(a:title, '\/') != -1
    echohl WarningMsg
    echo printf('ERROR: this plugin cant handle files including slash in title (title=%s)', a:title)
    echohl None
    return
  endif

  " open new slack buffer
  let bufname = slack_files#util#info2bufname(a:url, a:id, a:filetype, a:title)
  let contents = split(slack_files#api#helper#get(a:url), '\r\?\n')
  call slack_files#buffer#open(bufname, opener, contents)
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
function! slack_files#common#write(filename, contents, ...) abort "{{{
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
  call slack_files#buffer#open(new_bufname, 'edit', a:contents)
endfunction "}}}

" get token
" Return: Slack API token String
function! slack_files#common#get_token() abort "{{{
  let token_file = slack_files#token_file()
  let token_dir = fnamemodify(token_file, ':h')

  if filereadable(token_file)
    for line in readfile(token_file)
      return line
    endfor
    throw 'slack_files: token file is empty'
  else
    let token = input('Slack API Token: ')
    call slack_files#api#auth#test(token)
    if ! isdirectory(token_dir)
      call mkdir(token_dir, 'p')
    endif
    call writefile([token], token_file)
    return token
  endif
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo

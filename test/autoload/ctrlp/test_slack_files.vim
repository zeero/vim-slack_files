let s:suite = themis#suite('Test for autoload/ctrlp/slack_files.vim -')
let s:assert = themis#helper('assert')

function! s:suite.before() "{{{
  let g:ctrlp_ext_vars = []
  let g:ctrlp_builtins = 0
endfunction "}}}

function! s:suite.after() "{{{
  exe 'source autoload/slack_files/api/files.vim'
  exe 'source autoload/slack_files/util.vim'
endfunction "}}}

function! s:suite.init()
  let title = 'dummy_title'
  let filetype = 'dummy_filetype'
  let url = 'dummy_url'
  let id = 'dummy_id'
  let timestamp = 1
  let mock_value = {'files': [{
  \ 'title': title,
  \ 'filetype': filetype,
  \ 'url_private': url,
  \ 'id': id,
  \ 'timestamp': timestamp,
  \}]}
  try
    call vmock#mock('slack_files#api#files#list').return(mock_value).once()
    let actual = ctrlp#slack_files#init()
    let expected = [printf("%s\t<%s>\t%s\t%s", title, filetype, url, id)]
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.init_returns_list_sorted_by_timestamp_desc()
  let title = 'dummy_title'
  let filetype = 'dummy_filetype'
  let url = 'dummy_url'
  let id = 'dummy_id'
  let timestamp = 1
  let title2 = 'dummy_title_'
  let filetype2 = 'dummy_filetype_'
  let url2 = 'dummy_url_'
  let id2 = 'dummy_id_'
  let timestamp2 = 2
  let mock_value = {'files': [{
  \ 'title': title,
  \ 'filetype': filetype,
  \ 'url_private': url,
  \ 'id': id,
  \ 'timestamp': timestamp,
  \},{
  \ 'title': title2,
  \ 'filetype': filetype2,
  \ 'url_private': url2,
  \ 'id': id2,
  \ 'timestamp': timestamp2,
  \}]}
  try
    call vmock#mock('slack_files#api#files#list').return(mock_value).once()
    let actual = ctrlp#slack_files#init()
    let expected = [
    \ printf("%s\t<%s>\t%s\t%s", title2, filetype2, url2, id2),
    \ printf("%s\t<%s>\t%s\t%s", title, filetype, url, id),
    \]
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.init_can_returns_empty_list()
  let mock_value = {'files': []}
  try
    call vmock#mock('slack_files#api#files#list').return(mock_value).once()
    let actual = ctrlp#slack_files#init()
    let expected = []
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.accept()
  let mode = 'e'
  let title = 'dummy_title'
  let filetype = 'dummy_filetype'
  let url = 'dummy_url'
  let id = 'dummy_id'
  let str = printf("%s\t<%s>\t%s\t%s", title, filetype, url, id)

  try
    call vmock#mock('slack_files#util#info2bufname').with(url, id, filetype, title).return('mock_value').once()
    call ctrlp#slack_files#accept(mode, str)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction


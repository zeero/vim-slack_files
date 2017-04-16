let s:suite = themis#suite('Test for autoload/slack_files/common.vim -')
let s:assert = themis#helper('assert')

function! s:suite.after() "{{{
  exe 'source autoload/slack_files/api/helper.vim'
  exe 'source autoload/slack_files/buffer.vim'
endfunction "}}}

function! s:suite.open()
  let url = 'http://mock_url'
  let id = 'mock_id'
  let filetype = 'mock_filetype'
  let title = 'mock_title'
  let bufname = slack_files#util#info2bufname(url, id, filetype, title)
  try
    call vmock#mock('slack_files#api#helper#get').with(url).return("mock line1\nmock line 2").once()
    call vmock#mock('slack_files#buffer#open').with(bufname, 'edit', ['mock line1', 'mock line 2']).once()
    call slack_files#common#open(url, id, filetype, title)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.open_is_configurable_for_opener()
  let url = 'http://mock_url'
  let id = 'mock_id'
  let filetype = 'mock_filetype'
  let title = 'mock_title'
  let bufname = slack_files#util#info2bufname(url, id, filetype, title)
  let opener = 'tabe'
  try
    call vmock#mock('slack_files#api#helper#get').with(url).return("mock line1\nmock line 2").once()
    call vmock#mock('slack_files#buffer#open').with(bufname, opener, ['mock line1', 'mock line 2']).once()
    call slack_files#common#open(url, id, filetype, title, {'opener': opener})
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.open_do_nothing_when_title_includes_slash()
  let url = 'http://mock_url'
  let id = 'mock_id'
  let filetype = 'mock_filetype'
  let title = 'mock_title/has_slash'
  try
    call vmock#mock('slack_files#api#helper#get').never()
    call vmock#mock('slack_files#buffer#open').never()
    call slack_files#common#open(url, id, filetype, title)
    
    " TODO
    call s:assert.skip('TODO: never() cant work - Key not present in Dictionary: __actual_args)')
    " call vmock#verify()
  catch /^Vim\%((\a\+)\)\=:E/
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.write()
  let filename = 'mock_filename'
  let contents = ['mock line1', 'mock line 2']

  let url = 'http://mock_url'
  let id = 'mock_id'
  let filetype = 'mock_filetype'
  let title = 'mock_title'
  let res = {
  \ 'file': {
  \   'url_private': url,
  \   'id': id,
  \   'filetype': filetype,
  \   'title': title,
  \ }
  \}
  let bufname = slack_files#util#info2bufname(url, id, filetype, title)

  " TODO
  call s:assert.skip('TODO: vmock cant work with variable args.')

  try
    call vmock#mock('slack_files#api#files#upload').with(filename, contents, {}).return(res).once()
    call vmock#mock('slack_files#buffer#open').with(bufname, 'edit', contents).once()
    call slack_files#common#write(filename, contents)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.get_token_returns_first_line_of_token_file()
  let g:slack_files#token_file = 'test/fixtures/token/valid_token'
  let actual = slack_files#common#get_token()
  let expected = 'dummy_token'
  call s:assert.equals(actual, expected)

  unlet g:slack_files#token_file
endfunction

function! s:suite.get_token_throw_exception_when_token_file_is_empty()
  let g:slack_files#token_file = 'test/fixtures/token/empty_token'
  try
    call slack_files#common#get_token()
    call s:assert.fail('Unreachable')
  catch /^slack_files: token file is empty/
    call s:assert.true(1)
    return
  finally
    unlet g:slack_files#token_file
  endtry
  call s:assert.fail('Unreachable')
endfunction


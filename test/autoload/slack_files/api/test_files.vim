let s:suite = themis#suite('Test for autoload/slack_files/api/files.vim -')
let s:assert = themis#helper('assert')

function! s:suite.after() "{{{
  exe 'source autoload/slack_files/api/helper.vim'
endfunction "}}}

function! s:suite.upload()
  let filename = 'dummy_filename'
  let contents = ['dummy_line1', 'dummy_line2']
  let post_data = {
  \ 'filename': filename,
  \ 'content': "dummy_line1\ndummy_line2",
  \}
  let expected = 'mock value'
  try
    call vmock#mock('slack_files#api#helper#post').with('files.upload', post_data).return(expected).once()
    let actual = slack_files#api#files#upload(filename, contents)
    call s:assert.equals(actual, expected)

    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.upload_with_config()
  let filename = 'dummy_filename'
  let contents = ['dummy_line1', 'dummy_line2']
  let title = '0'
  let filetype = '0'
  let comment = '0'
  let channels = '0'
  let config = {
  \ 'title': title,
  \ 'filetype': filetype,
  \ 'comment': comment,
  \ 'channels': channels,
  \}
  let post_data = {
  \ 'filename': filename,
  \ 'content': "dummy_line1\ndummy_line2",
  \ 'title': title,
  \ 'filetype': filetype,
  \ 'initial_comment': comment,
  \ 'channels': channels,
  \}
  let expected = 'mock value'
  try
    call vmock#mock('slack_files#api#helper#post').with('files.upload', post_data).return(expected).once()
    let actual = slack_files#api#files#upload(filename, contents, config)
    call s:assert.equals(actual, expected)

    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.list()
  let expected = 'mock value'
  try
    call vmock#mock('slack_files#api#helper#post').with('files.list', {'types': g:slack_files#list_types}).return(expected).once()
    let actual = slack_files#api#files#list()
    call s:assert.equals(actual, expected)

    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.delete()
  let id = 'dummy'
  let expected = 'mock value'
  try
    call vmock#mock('slack_files#api#helper#post').with('files.delete', {'file': id}).return(expected).once()
    let actual = slack_files#api#files#delete(id)
    call s:assert.equals(actual, expected)

    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction


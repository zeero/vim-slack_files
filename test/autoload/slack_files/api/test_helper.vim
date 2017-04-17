let s:suite = themis#suite('Test for autoload/slack_files/api/helper.vim -')
let s:assert = themis#helper('assert')

function! s:suite.after() "{{{
  exe 'source autoload/slack_files/common.vim'
endfunction "}}}

function! s:suite.post()
  try
    call vmock#mock('slack_files#common#get_token').return('').once()
    let actual = slack_files#api#helper#post('api.test', {})
    let expected = {
    \ 'args': {
    \   'token': '',
    \ },
    \ 'ok': 1,
    \}
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.post_with_token_specified()
  let token = ''
  let actual = slack_files#api#helper#post('api.test', {'token': token})
  let expected = {
  \ 'args': {
  \   'token': token,
  \ },
  \ 'ok': 1,
  \}
  call s:assert.equals(actual, expected)
endfunction

function! s:suite.post_throw_exception_when_api_error()
  let token = ''
  try
    call slack_files#api#helper#post('api.test', {'error': 'dummy', 'token': token})
    call s:assert.fail('Unreachable')
  catch /^slack_files: Slack API error$/
    call s:assert.true(1)
    return
  endtry
  call s:assert.fail('Unreachable')
endfunction

function! s:suite.post_throw_exception_when_network_error()
  let token = ''
  try
    call slack_files#api#helper#post('../notfound', {'token': token})
    call s:assert.fail('Unreachable')
  catch /^slack_files: Slack API network error/
    call s:assert.true(1)
    return
  endtry
  call s:assert.fail('Unreachable')
endfunction

function! s:suite.post_throw_exception_when_json_decode_fails()
  let token = ''
  try
    call slack_files#api#helper#post('..', {'token': token})
    call s:assert.fail('Unreachable')
  catch /^Vim\%((\a\+)\)\=:E15/
    call s:assert.true(1)
    return
  endtry
  call s:assert.fail('Unreachable')
endfunction

function! s:suite.get()
  let url = 'https://slack.com/api/get'
  try
    call vmock#mock('slack_files#common#get_token').return('').once()
    let actual = slack_files#api#helper#get(url)
    let expected = '{"ok":false,"error":"unknown_method","req_method":"get"}'
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.get_throw_exception_when_network_error()
  let url = 'https://slack.com/notfound'
  try
    call vmock#mock('slack_files#common#get_token').return('').once()
    call slack_files#api#helper#get(url)
    call s:assert.fail('Unreachable')
  catch /^slack_files: Slack API network error/
    call s:assert.true(1)
    return
  catch
    echoerr v:exception
  finally
    call vmock#verify()
    call vmock#clear()
  endtry
  call s:assert.fail('Unreachable')
endfunction


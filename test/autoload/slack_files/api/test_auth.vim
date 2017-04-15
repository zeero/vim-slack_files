let s:suite = themis#suite('Test for autoload/slack_files/api/auth.vim -')
let s:assert = themis#helper('assert')

function! s:suite.after() "{{{
  exe 'source autoload/slack_files/api/helper.vim'
endfunction "}}}

function! s:suite.test()
  let token = 'dummy'
  try
    call vmock#mock('slack_files#api#helper#post').with('auth.test', {'token': token}).return('mock value').once()
    call slack_files#api#auth#test(token)
    call s:assert.true(1)

    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.test_throws_exception_if_token_is_empty()
  try
    call slack_files#api#auth#test('')
    call s:assert.fail('Unreachable')
  catch /^slack_files: token is empty$/
    call s:assert.true(1)
    return
  endtry
  call s:assert.fail('Unreachable')
endfunction

function! s:suite.test_throws_exception_if_token_is_invalid()
  try
    call slack_files#api#auth#test('invalid')
    call s:assert.fail('Unreachable')
  catch /^slack_files: invalid token$/
    call s:assert.true(1)
    return
  endtry
  call s:assert.fail('Unreachable')
endfunction


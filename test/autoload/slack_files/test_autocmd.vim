let s:suite = themis#suite('Test for autoload/slack_files/autocmd.vim -')
let s:assert = themis#helper('assert')

function! s:suite.after() "{{{
  " exe 'source autoload/slack_files/api/helper.vim'
endfunction "}}}

function! s:suite.onBufWriteCmd()
  " TODO
  call s:assert.skip('TODO: vmock cant work with variable args.')

  let expected = 'mock value'
  try
    call vmock#mock('slack_files#write').return(expected . ' for write').once()
    call vmock#mock('slack_files#api#helper#post').return(expected).once()
    let actual = slack_files#autocmd#onBufWriteCmd('vimslackfiles://this.is.slack.buffer/url/ID/filetype/title')
    call s:assert.equals(actual, expected)
    
    call vmock#verify()
  catch
    echoerr v:exception
  finally
    call vmock#clear()
  endtry
endfunction

function! s:suite.onBufWriteCmd_return_null_with_normal_buffer_name()
  let actual = slack_files#autocmd#onBufWriteCmd('/this/is/not/slack/buffer')
  let expected = 0
  call s:assert.equals(actual, expected)
endfunction

